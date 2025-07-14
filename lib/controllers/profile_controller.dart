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
  var followStatusMap = <String, RxBool>{}.obs;
  RxInt followersCount = 0.obs;
  RxInt followingCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  void getUserData({String? otherId}) async {
    final userId = otherId ?? auth.currentUser?.uid;
    if (userId != null) {
      final docRef = await firestore.collection('Users').doc(userId).get();
      userModel.value = UserModel.fromJson(
        docRef.data() as Map<String, dynamic>,
      );
      fetchFollowersAndFollowing();
    }
  }

  Future<bool> follow(bool isFollowed, String followingId) async {
    final docId = '${auth.currentUser?.uid}_$followingId';
    final docRef = firestore.collection('Follows').doc(docId);
    console('isFollowed: $isFollowed, followingId: $followingId');
    await docRef.set({
      'isFollowed': isFollowed,
      'followerId': auth.currentUser?.uid,
      'followingId': followingId,
      'timeStamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    getFollowStatus(followingId);
    fetchFollowersAndFollowing();
    followStatusMap[followingId] = isFollowed.obs;

    await notificationsController.createNotification(
      type: isFollowed ? 'follow' : 'unfollow',
      senderId: auth.currentUser!.uid,
      receiverId: followingId,
      message: isFollowed ? 'started following you.' : 'unfollowed you.',
    );

    return true;
  }

  Future<void> loadFollowStatus(String userId) async {
    if (!followStatusMap.containsKey(userId)) {
      final isFollowing = await getFollowStatus(userId);
      followStatusMap[userId] = isFollowing.obs;
    }
  }

  Future<bool> getFollowStatus(String followingUserId) async {
    final docId = '${auth.currentUser?.uid}_$followingUserId';
    final docRef = FirebaseFirestore.instance.collection('Follows').doc(docId);
    final doc = await docRef.get();
    console('isFollow after ${doc['isFollowed']}');

    if (doc.exists && doc['isFollowed'] == true
    // &&
    // doc['followingId'] != auth.currentUser?.uid
    ) {
      return true;
    }
    return false;
  }

  void fetchFollowersAndFollowing() async {
    try {
      // Count followers (users who follow current user)
      final followersSnapshot =
          await firestore
              .collection('Follows')
              .where('followingId', isEqualTo: auth.currentUser?.uid)
              .where('isFollowed', isEqualTo: true)
              .get();

      followersCount.value = followersSnapshot.docs.length;

      // Count following (users whom current user follows)
      final followingSnapshot =
          await firestore
              .collection('Follows')
              .where('followerId', isEqualTo: auth.currentUser?.uid)
              .where('isFollowed', isEqualTo: true)
              .get();

      followingCount.value = followingSnapshot.docs.length;
    } catch (e) {
      console('Error fetching follow data: $e');
    }
  }
}
