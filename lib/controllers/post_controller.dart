import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:social_media/components/custom_bottom_nav_bar.dart';
import 'package:social_media/controllers/notifications_controller.dart';
import 'package:social_media/models/comments_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/shared/console.dart';
import 'package:social_media/views/home/home_view.dart';

class PostController extends GetxController {
  final notificationsController = Get.put(NotificationsController());
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  User? user;
  UserModel? userData;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxString image = ''.obs;
  RxList<PostModel> posts = <PostModel>[].obs;
  RxMap<String, int> likesCounts = <String, int>{}.obs;
  RxMap<String, int> commentsCounts = <String, int>{}.obs;
  RxMap<String, int> commentsLikesCount = <String, int>{}.obs;

  // final Uuid uuid = Uuid();

  Future<void> createPost(
    String? filePath,
    String? text,
    String postType,
  ) async {
    console('text before upload: $text');

    try {
      String? downloadUrl;

      // Upload file only if filePath is not null or empty
      if (filePath != null && filePath.isNotEmpty) {
        final file = File(filePath);
        if (!await file.exists()) {
          console('File does not exist: $filePath');
          Get.snackbar('Error', 'Selected media not found.');
          return;
        }

        final String extension = postType == 'video' ? 'mp4' : 'jpg';
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch}.$extension';
        final Reference ref = storage.ref().child("Posts/$fileName");
        final UploadTask uploadTask = ref.putFile(file);
        final TaskSnapshot snapshot = await uploadTask;
        downloadUrl = await snapshot.ref.getDownloadURL();
      }

      if ((text == null || text.trim().isEmpty) && downloadUrl == null) {
        Get.snackbar('Error', 'Please add text or media.');
        return;
      }

      final uid = auth.currentUser?.uid;
      if (uid == null) {
        Get.snackbar('Auth Error', 'User not logged in.');
        return;
      }

      final DocumentReference docRef = firestore.collection('Posts').doc();
      final String postId = docRef.id;

      await docRef.set({
        'postId': postId,
        'postType': postType,
        'isLiked': false,
        'mediaUrl': downloadUrl ?? '',
        'text': text?.trim() ?? '',
        'userId': uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      console('Post created: $postId');
      Get.snackbar('Success', 'Post uploaded successfully');
      //  Get.off(() => CustomBottomNavBar());
    } catch (e) {
      console('Error creating post: $e');
      Get.snackbar('Error', 'Failed to create post');
    }
  }

  Stream<List<PostModel>> getPostsStream() {
    return firestore
        .collection('Posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          List<PostModel> posts = [];

          for (var doc in snapshot.docs) {
            final userId = doc['userId'];
            final userDoc =
                await firestore.collection('Users').doc(userId).get();
            final userModel = UserModel.fromJson(
              userDoc.data() as Map<String, dynamic>,
            );

            final post = PostModel.fromJson(doc.data(), user: userModel);

            posts.add(post);
            getLikes(post.postId);
            getCommentsLength(post.postId);
            getComments(post.postId);
          }

          return posts;
        });
  }

  Stream<PostModel> getPost(String postId) {
    return firestore
        .collection('Posts')
        .doc(postId)
        .snapshots()
        .map((doc) => PostModel.fromJson(doc.data()!));
  }

  Future<void> likePost(String userId, String postId, bool isLiked) async {
    final likePostId = '${postId}_$userId';
    DocumentReference docRef = firestore.collection('Likes').doc(likePostId);

    await docRef.set({
      'isLiked': isLiked,
      'likeId': likePostId,
      'postId': postId,
      'likedBy': auth.currentUser?.uid,
    });
    firestore.collection('Posts').doc(postId).update({'isLiked': isLiked});
    getLikes(postId);
    if (isLiked) {
      await notificationsController.createNotification(
        type: 'like',
        senderId: auth.currentUser!.uid,
        receiverId: userId, // person who owns the post
        postId: postId,
        message: 'liked your post!',
      );
    }
  }

  void getLikes(postId) async {
    final likesSnapshot =
        await firestore
            .collection('Likes')
            .where('postId', isEqualTo: postId)
            .where('isLiked', isEqualTo: true)
            .get();
    likesCounts[postId] = likesSnapshot.docs.length;
  }

  Future<void> addComment(String postId, String comment) async {
    // final likePostId = '${postId}_$userId';
    DocumentReference docRef = firestore.collection('Comments').doc();
    final commentId = docRef.id;
    await docRef.set({
      'commentId': commentId,
      'postId': postId,
      'commentBy': auth.currentUser?.uid,
      'comment': comment,
      'timeStamp': FieldValue.serverTimestamp(),
    });

    getCommentsLength(postId);
    final postSnapshot = await firestore.collection('Posts').doc(postId).get();
    final receiverId = postSnapshot['userId'];

    await notificationsController.createNotification(
      type: 'comment',
      commentId: commentId,
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      postId: postId,
      message: 'commented on your post: "$comment"',
    );
  }

  Future<void> likeComment(
    String commentId,
    String postId,
    bool isLiked,
  ) async {
    final likePostId = '${commentId}_${auth.currentUser?.uid}';
    console('isLiked $isLiked');
    DocumentReference docRef = firestore
        .collection('Comments')
        .doc(commentId)
        .collection('Likes')
        .doc(likePostId);

    await docRef.set({
      'isLiked': isLiked,
      'likeId': likePostId,
      'likedBy': auth.currentUser?.uid,
    });
    firestore.collection('Comments').doc(commentId).update({
      'isLiked': isLiked,
    });
    getCommentLikes(commentId);
    final commentSnapshot =
        await firestore.collection('Comments').doc(commentId).get();
    final receiverId = commentSnapshot['commentBy'];
    // Send notification only when liked (not when unliked)
    if (isLiked) {
      await notificationsController.createNotification(
        type: 'like_comment',
        senderId: auth.currentUser!.uid,
        receiverId: receiverId,
        postId: postId,
        commentId: commentId,
        message: 'liked your comment: "${commentSnapshot['comment']}"',
      );
    }
  }

  void getCommentLikes(commentId) async {
    final likesSnapshot =
        await firestore
            .collection('Comments')
            .doc(commentId)
            .collection('Likes')
            .where('isLiked', isEqualTo: true)
            .get();
    commentsLikesCount[commentId] = likesSnapshot.docs.length;
  }

  void getCommentsLength(postId) async {
    final commentsSnapshot =
        await firestore
            .collection('Comments')
            .where('postId', isEqualTo: postId)
            .get();
    commentsCounts[postId] = commentsSnapshot.docs.length;
  }

  Stream<List<CommentsModel>> getComments(String postId) {
    return firestore
        .collection('Comments')
        .where('postId', isEqualTo: postId)
        // .orderBy('timeStamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          console('Docs received: ${snapshot.docs.length}');

          return await Future.wait(
            snapshot.docs.map((doc) async {
              final userSnapshot =
                  await firestore
                      .collection('Users')
                      .doc(doc['commentBy'])
                      .get();
              console('doc: ${doc['comment']}');
              getCommentLikes(doc['commentId']);

              final userModel = UserModel.fromJson(
                userSnapshot.data() as Map<String, dynamic>,
              );
              return CommentsModel.fromJson(doc.data(), user: userModel);
            }),
          );
        });
  }
}
