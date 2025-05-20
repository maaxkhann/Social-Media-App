import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_media/controllers/notifications_controller.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/shared/console.dart';

class ProfileController extends GetxController {
  final notificationsController = Get.put(NotificationsController());
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData() async {
    final userId = auth.currentUser?.uid;
    if (userId != null) {
      final docRef = await firestore.collection('Users').doc(userId).get();
      userModel.value = UserModel.fromJson(
        docRef.data() as Map<String, dynamic>,
      );
      console('asldasdkl ${userModel.value}');
    }
  }

  Future<bool> follow(bool isFollowed, String followingId) async {
    final docId = '${auth.currentUser?.uid}_$followingId';
    final docRef = firestore.collection('Follows').doc(docId);
    await docRef.set({
      'isFollowed': isFollowed,
      'followerId': auth.currentUser?.uid,
      'followingId': followingId,
      'timeStamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    getFollowStatus(followingId);
    await notificationsController.createNotification(
      type: isFollowed ? 'follow' : 'unfollow',
      senderId: auth.currentUser!.uid,
      receiverId: followingId,
      message: isFollowed ? 'started following you.' : 'unfollowed you.',
    );

    return true;
  }

  Future<bool> getFollowStatus(String followingUserId) async {
    final docId = '${auth.currentUser?.uid}_$followingUserId';
    final docRef = FirebaseFirestore.instance.collection('Follows').doc(docId);
    final doc = await docRef.get();

    if (doc.exists && doc['isFollowed'] == true) {
      // UNFOLLOW

      return true;
    }
    return false;
  }
}
