import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_media/models/chat_model.dart';
import 'package:social_media/models/chat_user_model.dart';
import 'package:social_media/models/user_model.dart';
import 'package:social_media/services/notification_service.dart';

const String usersCollec = "users";
const String chatUsersCollec = "chatUsers";
const String chatsCollec = "chats";

class ChatController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference chatUsersRef = FirebaseFirestore.instance.collection(
    chatUsersCollec,
  );
  CollectionReference chatsRef = FirebaseFirestore.instance.collection(
    chatsCollec,
  );

  String channelId(String senderId, String otherId) {
    List<String> ids = [senderId, otherId];
    ids.sort();
    return ids.join('_');
  }

  Future<void> sendMessage({
    required String currentUserId,
    required String? otherUserId, // optional for group
    required String messageText,
    String? voiceUrl,
    String? chatId, // required for group
    bool isGroup = false,
  }) async {
    final now = FieldValue.serverTimestamp();
    if (!isGroup) {
      chatId = channelId(currentUserId, otherUserId!);
    }

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    // Send message
    await chatRef.collection('messages').add({
      'senderId': currentUserId,
      'text': messageText,
      'voiceUrl': voiceUrl,
      'timestamp': now,
      'read': false,
    });

    // Update last message for participants
    if (isGroup) {
      final chatDoc = await chatRef.get();
      final participants = List<String>.from(
        chatDoc.data()?['participants'] ?? [],
      );

      for (String uid in participants) {
        await chatUsersRef
            .doc(uid)
            .collection(chatUsersCollec)
            .doc(chatId)
            .set({
              'lastMessage': messageText,
              'lastMessageTimestamp': now,
              'chatId': chatId,
              'isGroup': true,
            });
      }
    } else {
      await chatUsersRef
          .doc(currentUserId)
          .collection(chatUsersCollec)
          .doc(chatId)
          .set({
            'lastMessage': messageText,
            'lastMessageTimestamp': now,
            'otherUserId': otherUserId,
            'isGroup': false,
          });

      await chatUsersRef
          .doc(otherUserId!)
          .collection(chatUsersCollec)
          .doc(chatId)
          .set({
            'lastMessage': messageText,
            'lastMessageTimestamp': now,
            'otherUserId': currentUserId,
            'isGroup': false,
          })
          .then((val) async {
            final userData =
                await firestore.collection('Users').doc(otherUserId).get();
            final currentUser =
                await firestore.collection('Users').doc(currentUserId).get();
            await NotificationServices().sendFCMNotification(
              token: userData.data()?['fcmToken'],
              title: currentUser.data()?['name'] ?? 'unknown',
              body:
                  messageText.isNotEmpty
                      ? messageText
                      : 'sent you voice message',
            );
          });
    }
  }

  final RxList<ChatModel> _msgList = <ChatModel>[].obs;
  RxList<ChatModel> get msgList => _msgList;
  DocumentSnapshot? lastMsgDoc;
  RxBool isLoadingMoreMsgs = false.obs;
  RxBool isInitialLoading = true.obs;

  bool hasMore = false;

  Future<void> getMessages({required String chatId, limit = 12}) async {
    if (isLoadingMoreMsgs.value) isInitialLoading.value = true;
    isLoadingMoreMsgs.value = true;
    Query query = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit);
    if (lastMsgDoc != null) {
      query = query.startAfterDocument(lastMsgDoc!);
    }
    QuerySnapshot querySnapshot = await query.get();
    final newMessages =
        querySnapshot.docs
            .map((doc) => ChatModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
    _msgList.addAll(newMessages);
    lastMsgDoc = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
    hasMore = querySnapshot.docs.length == limit;
    isLoadingMoreMsgs.value = false;
      isInitialLoading.value = false; // mark initial load complete


    // .snapshots()
    // .map(
    //   (snapshot) =>
    //       snapshot.docs
    //           .map((doc) => ChatModel.fromMap(doc.data()))
    //           .toList(),
    // );
  }

  Stream<List<ChatUserModel>> getUserChats(String uid) {
    return firestore
        .collection('chatUsers')
        .doc(uid)
        .collection('chatUsers')
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
          final chatList = await Future.wait(
            snapshot.docs.map((doc) async {
              final data = doc.data();
              final otherUserId = data['otherUserId'];
              final chatId = channelId(uid, otherUserId);

              final unreadSnapshot =
                  await firestore
                      .collection('chats')
                      .doc(chatId)
                      .collection('messages')
                      .where('read', isEqualTo: false)
                      .where('senderId', isEqualTo: otherUserId)
                      .get();

              final unreadCount = unreadSnapshot.docs.length;

              // Fetch user document
              final userDoc =
                  await firestore.collection('Users').doc(otherUserId).get();
              final userData = userDoc.data() ?? {};

              final userModel = UserModel.fromJson(userData);

              return ChatUserModel.fromJson(
                data,
                user: userModel,
              ).copyWith(unreadCount: unreadCount);
            }),
          );

          return chatList;
        });
  }

  Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    final query =
        await FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .where('read', isEqualTo: false)
            .get();

    final docsToUpdate = query.docs.where(
      (doc) => doc['senderId'] != currentUserId,
    );

    for (var doc in docsToUpdate) {
      doc.reference.update({'read': true});
    }
  }

  //for group
  /// Create a new group with name and member UIDs
  Future<DocumentReference> createGroup(
    String groupName,
    List<String> userIds,
  ) {
    return firestore.collection('groups').add({
      'name': groupName,
      'members': userIds,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Send a message within a group
  Future<void> sendGroupMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required String senderImage,
    required String message,
    String? voiceUrl,
  }) async {
    final groupRef = firestore.collection('groups').doc(groupId);

    // Send the message
    await groupRef.collection('messages').add({
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'text': message,
      'voiceUrl': voiceUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'readBy': [senderId],
    });

    // Get group members
    final groupDoc = await groupRef.get();
    final members = List<String>.from(groupDoc['members']);

    // Get token for all members except sender
    for (final uid in members) {
      if (uid == senderId) continue;

      final userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      final token = userDoc['fcmToken'];

      if (token != null && token.toString().isNotEmpty) {
        await NotificationServices().sendFCMNotification(
          token: token,
          title: groupDoc['name'],
          body: "$senderName: $message",
        );
      }
    }
  }

  /// Listen to chat messages ordered by time, descending
  Stream<List<QueryDocumentSnapshot>> chatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs);
  }

  /// Retrieve all groups the current user is part of
  Stream<List<QueryDocumentSnapshot>> groupsOf(String userId) {
    return firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snap) => snap.docs);
  }
}
