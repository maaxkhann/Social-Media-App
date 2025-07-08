import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:social_media/models/notifications_model.dart';
import 'package:social_media/models/post_model.dart';
import 'package:social_media/models/reply_model.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/shared/console.dart';

class NotificationsController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  User? user;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createNotification({
    required String type, // 'like', 'comment', 'follow', etc.
    required String senderId,
    required String receiverId,
    String? postId,
    String? commentId,
    required String message,
  }) async {
    DocumentReference docRef = firestore.collection('Notifications').doc();
    final notificationId = docRef.id;

    // 🔸 Fetch sender user info from Firestore
    final senderSnapshot =
        await firestore.collection('Users').doc(senderId).get();

    final senderData = senderSnapshot.data();
    final senderName = senderData?['name'] ?? 'Unknown';
    final senderImage = senderData?['image'] ?? '';

    await docRef.set({
      'senderName': senderName,
      'senderImage': senderImage,
      'notificationId': notificationId,
      'type': type,
      'senderId': senderId, //currentId
      'receiverId': receiverId,
      'postId': postId,
      'commentId': commentId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  Stream<List<NotificationModel>> getNotifications() {
    return firestore
        .collection('Notifications')
        .where('receiverId', isEqualTo: auth.currentUser?.uid)
        //  .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          final notifications =
              snapshot.docs
                  .map((doc) => NotificationModel.fromJson(doc.data()))
                  .where((notif) => notif.senderId != auth.currentUser?.uid)
                  .toList();
          notifications.sort((a, b) {
            // Put items with null timestamps at the end
            if (a.timestamp == null && b.timestamp == null) return 0;
            if (a.timestamp == null) return 1;
            if (b.timestamp == null) return -1;
            return b.timestamp!.compareTo(a.timestamp!);
          });

          return notifications;
        });
  }

  Future<dynamic> markNotificationAsRead(
    String notificationId,
    String postId,
  ) async {
    console('notificationId: $notificationId, postId: $postId');
    try {
      await firestore.collection('Notifications').doc(notificationId).update({
        'isRead': true,
      });
      final doc = await firestore.collection('Posts').doc(postId).get();
      PostModel postModel = PostModel.fromJson(
        doc.data() as Map<String, dynamic>,
      );
      return postModel;
    } catch (e) {
      console('Error marking notification as read: $e');
      return;
    }
  }

  Future<void> addReply(String commentId, String reply) async {
    final userId = auth.currentUser!.uid;
    DocumentReference docRef =
        firestore
            .collection('Comments')
            .doc(commentId)
            .collection('Replies')
            .doc();

    await docRef.set({
      'replyId': docRef.id,
      'commentId': commentId,
      'reply': reply,
      'replyBy': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Optional: notify comment owner
    final commentDoc =
        await firestore.collection('Comments').doc(commentId).get();
    final receiverId = commentDoc['commentBy'];
    await createNotification(
      type: 'reply',
      senderId: userId,
      receiverId: receiverId,
      postId: commentDoc['postId'],
      commentId: commentId,
      message: 'replied to your comment: "$reply"',
    );
  }

  Stream<List<ReplyModel>> getRepliesStream(String commentId) {
    console('commentId $commentId');
    return firestore
        .collection('Comments')
        .doc(commentId)
        .collection('Replies')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .asyncMap((snapshot) async {
          try {
            final replies = await Future.wait(
              snapshot.docs.map((doc) async {
                final data = doc.data();
                final userDoc =
                    await firestore
                        .collection('Users')
                        .doc(data['replyBy'])
                        .get();
                final user = UserModel.fromJson(userDoc.data()!);
                return ReplyModel.fromJson(data, user: user);
              }),
            );
            console('repliessssssssssssssssss $replies');
            return replies;
          } catch (e, stack) {
            console('⚠️ Error in getCommentsReply: $e\n$stack');
            console('⚠️ Error in getCommentsReply: $stack');
            return []; // fallback to empty list to avoid UI crashing
          }
        });
  }

  Map<String, DocumentSnapshot?> lastReplyDocs = {};
  Map<String, bool> hasMoreReplies = {};
  Map<String, RxBool> isReplyLoading = {};
  Map<String, RxList<ReplyModel>> paginatedReplies = {};

  void initReplyPagination(String commentId) {
    lastReplyDocs[commentId] = null;
    hasMoreReplies[commentId] = true;
    isReplyLoading[commentId] = false.obs;
    paginatedReplies[commentId] = <ReplyModel>[].obs;
  }

  Future<void> fetchRepliesPaginated(String commentId) async {
    if (isReplyLoading[commentId]?.value == true ||
        hasMoreReplies[commentId] != true) {
      return;
    }

    isReplyLoading[commentId]?.value = true;

    Query query = firestore
        .collection('Comments')
        .doc(commentId)
        .collection('Replies')
        .orderBy('timestamp', descending: false)
        .limit(5);

    if (lastReplyDocs[commentId] != null) {
      query = query.startAfterDocument(lastReplyDocs[commentId]!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      hasMoreReplies[commentId] = false;
      isReplyLoading[commentId]?.value = false;
      return;
    }

    lastReplyDocs[commentId] = snapshot.docs.last;

    final replies = await Future.wait(
      snapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final userSnapshot =
            await firestore.collection('Users').doc(data['replyBy']).get();

        return ReplyModel.fromJson(
          data,
          user: UserModel.fromJson(userSnapshot.data()!),
        );
      }),
    );

    paginatedReplies[commentId]?.addAll(replies);
    isReplyLoading[commentId]?.value = false;
  }
}
