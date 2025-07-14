import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
    required String otherUserId,
    required String messageText,
  }) async {
    String chatId = channelId(currentUserId, otherUserId);

    // Add the message to the messages subcollection
    await FirebaseFirestore.instance
        .collection(chatsCollec)
        .doc(chatId)
        .collection('messages')
        .add({
          'senderId': currentUserId,
          'text': messageText,
          'timestamp': FieldValue.serverTimestamp(),
          'read': false,
        });
    chatUsersRef
        .doc(currentUserId)
        .collection(chatUsersCollec)
        .doc(chatId)
        .set({
          'lastMessage': messageText,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'otherUserId': otherUserId,
        });

    // Update the userChats subcollection for the other user
    await chatUsersRef
        .doc(otherUserId)
        .collection(chatUsersCollec)
        .doc(chatId)
        .set({
          'lastMessage': messageText,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'otherUserId': currentUserId,
        });
  }

  Stream<List<Map<String, dynamic>>> getMessages(
    String currentUserId,
    String otherUserId,
  ) async* {
    String chatId = channelId(currentUserId, otherUserId);
    yield* FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
