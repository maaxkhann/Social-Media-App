import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media/models/notifications_model.dart';
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
      //  'commentId': commentId,
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

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await firestore.collection('Notifications').doc(notificationId).update({
        'isRead': true,
      });
    } catch (e) {
      console('Error marking notification as read: $e');
    }
  }
}
