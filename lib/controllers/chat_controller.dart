import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_media/models/chat_user_model.dart';
import 'package:social_media/models/user_model.dart';

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
          });
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages({required String chatId}) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
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

              // Fetch user document
              final userDoc =
                  await firestore.collection('Users').doc(otherUserId).get();
              final userData = userDoc.data() ?? {};

              final userModel = UserModel.fromJson(userData);

              return ChatUserModel.fromJson(data, user: userModel);
            }),
          );

          return chatList;
        });
  }
}
