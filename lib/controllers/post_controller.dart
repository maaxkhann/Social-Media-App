import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
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

  // final Uuid uuid = Uuid();

  Future<void> createPost(String filePath, String text, String postType) async {
    try {
      final file = File(filePath);
      // Determine extension based on type
      final String extension = postType == 'video' ? 'mp4' : 'jpg';
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$extension';
      final Reference ref = storage.ref().child("Posts/$fileName");
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      DocumentReference docRef = firestore.collection('Posts').doc();
      final postId = docRef.id;
      await docRef.set({
        await docRef.set({
          'postId': postId,
          'postType': postType,
          'isLiked': false,
          'mediaUrl': downloadUrl,
          'text': text,
          'userId': auth.currentUser?.uid,
          'timestamp': FieldValue.serverTimestamp(),
        }),
      });

      Get.off(() => HomeView());
    } catch (e) {}
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

              final userModel = UserModel.fromJson(
                userSnapshot.data() as Map<String, dynamic>,
              );
              return CommentsModel.fromJson(doc.data(), user: userModel);
            }),
          );
        });
  }
}
