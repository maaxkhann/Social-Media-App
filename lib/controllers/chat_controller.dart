import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:social_media/models/chat_model.dart';
import 'package:social_media/models/chat_user_model.dart';
import 'package:social_media/models/group_messages_model.dart';
import 'package:social_media/models/group_model.dart';
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
              'unreadCount': uid == currentUserId ? 0 : FieldValue.increment(1),
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
            'unreadCount': 0,
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
            'unreadCount': FieldValue.increment(1),
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
  StreamSubscription? _realtimeSub;

  /// Listen to real-time messages (only new ones)
  void listenToMessages(String chatId) {
    // Cancel previous listener (if any)
    _realtimeSub?.cancel();

    _realtimeSub = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1) // Only listen for the newest message
        .snapshots()
        .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final newMsg = ChatModel.fromMap({
                'id': change.doc.id,
                ...change.doc.data() as Map<String, dynamic>,
              });

              if (_msgList.isEmpty || _msgList.first.id != newMsg.id) {
                _msgList.insert(0, newMsg); // Add new messages to the top
              }
            }
          }
        });
  }

  /// Paginate older messages (no stream, just once)
  Future<void> getMessages({required String chatId, limit = 12}) async {
    if (isLoadingMoreMsgs.value) return;
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
        querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return ChatModel.fromMap({'id': doc.id, ...data});
        }).toList();

    _msgList.addAll(newMessages);
    lastMsgDoc =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : lastMsgDoc;
    hasMore = querySnapshot.docs.length == limit;

    isLoadingMoreMsgs.value = false;
    isInitialLoading.value = false;
  }

  void refreshChat() {
    _msgList.clear();
    lastMsgDoc = null;
    isInitialLoading.value = true;
    hasMore = false;
    _realtimeSub?.cancel();
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

  Future<void> resetUnreadCount(String chatId, String userId) async {
    final chatDocRef = chatUsersRef
        .doc(userId)
        .collection(chatUsersCollec)
        .doc(chatId);
    await chatDocRef.update({'unreadCount': 0});
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
    final now = FieldValue.serverTimestamp();
    final groupRef = firestore.collection('groups').doc(groupId);

    // Add new message to the group's messages collection
    final newMessageRef = groupRef.collection('messages').doc();
    await newMessageRef.set({
      'senderId': senderId,
      'senderName': senderName,
      'senderImage': senderImage,
      'text': message,
      'voiceUrl': voiceUrl,
      'timestamp': now,
      'readBy': [senderId], // sender has already "read" it
    });

    // Fetch group data (members + name)
    final groupDoc = await groupRef.get();
    if (!groupDoc.exists) return;

    final members = List<String>.from(groupDoc.data()?['members'] ?? []);
    final groupName = groupDoc.data()?['name'] ?? 'Group Chat';

    // Create a batch to update unread counts
    final batch = firestore.batch();

    for (final uid in members) {
      final memberRef = groupRef.collection('members').doc(uid);

      if (uid == senderId) {
        // Sender's unread count should reset to 0
        batch.set(memberRef, {'unreadCount': 0}, SetOptions(merge: true));
      } else {
        // Increment unread count for each other member
        batch.set(memberRef, {
          'unreadCount': FieldValue.increment(1),
          'lastMessage': message.isNotEmpty ? message : '🎤 Voice message',
          'lastMessageTimestamp': now,
        }, SetOptions(merge: true));
      }
    }

    await batch.commit();

    // Send FCM notifications to all members except sender
    final notificationTasks = members.where((uid) => uid != senderId).map((
      uid,
    ) async {
      final userDoc = await firestore.collection('Users').doc(uid).get();
      final token = userDoc.data()?['fcmToken'];

      if (token != null && token.toString().isNotEmpty) {
        await NotificationServices().sendFCMNotification(
          token: token,
          title: groupName,
          body:
              message.isNotEmpty
                  ? "$senderName: $message"
                  : "$senderName sent a voice message",
        );
      }
    });

    await Future.wait(notificationTasks);
  }

  // /// Listen to chat messages ordered by time, descending
  Stream<List<GroupMessagesModel>> chatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true) // ✅ fixed field name
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => GroupMessagesModel.fromDoc(doc)).toList(),
        );
  }

  final RxList<GroupMessagesModel> _groupMsgList = <GroupMessagesModel>[].obs;
  RxList<GroupMessagesModel> get groupMsgList => _groupMsgList;

  DocumentSnapshot? lastGroupMsgDoc;
  RxBool isLoadingMoreGroupMsgs = false.obs;
  RxBool isInitialGroupLoading = true.obs;
  bool hasMoreGroup = false;
  StreamSubscription? _groupRealtimeSub;

  /// Real-time listener for latest group messages
  void listenToGroupMessages(String groupId) {
    _groupRealtimeSub?.cancel();

    _groupRealtimeSub = firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          for (var change in snapshot.docChanges) {
            final newMsg = GroupMessagesModel.fromDoc(change.doc);

            if (change.type == DocumentChangeType.added) {
              if (_groupMsgList.isEmpty ||
                  _groupMsgList.first.id != newMsg.id) {
                _groupMsgList.insert(0, newMsg);
              }
            } else if (change.type == DocumentChangeType.modified) {
              final index = _groupMsgList.indexWhere((m) => m.id == newMsg.id);
              if (index != -1) {
                _groupMsgList[index] =
                    newMsg; // update timestamp and other fields
              }
            }
          }
        });
  }

  /// Pagination for older group messages
  Future<void> getGroupMessages({
    required String groupId,
    int limit = 12,
  }) async {
    if (isLoadingMoreGroupMsgs.value) return;

    isLoadingMoreGroupMsgs.value = true;

    Query query = firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(limit);

    if (lastGroupMsgDoc != null) {
      query = query.startAfterDocument(lastGroupMsgDoc!);
    }

    QuerySnapshot querySnapshot = await query.get();
    final newMessages =
        querySnapshot.docs
            .map((doc) => GroupMessagesModel.fromDoc(doc))
            .toList();

    _groupMsgList.addAll(newMessages);
    lastGroupMsgDoc =
        querySnapshot.docs.isNotEmpty
            ? querySnapshot.docs.last
            : lastGroupMsgDoc;
    hasMoreGroup = querySnapshot.docs.length == limit;

    isLoadingMoreGroupMsgs.value = false;
    isInitialGroupLoading.value = false;
  }

  /// Refresh/reset group chat state
  void refreshGroupChat(String groupId) {
    _groupMsgList.clear();
    isInitialGroupLoading.value = true;
    lastGroupMsgDoc = null;
    hasMoreGroup = false;
    _groupRealtimeSub?.cancel();
  }

  /// Retrieve all groups the current user is part of
  Stream<List<GroupModel>> groupsOf(String userId) {
    return firestore
        .collection('groups')
        .where('members', arrayContains: userId)
        .snapshots()
        .asyncMap((snap) async {
          return await Future.wait(
            snap.docs.map((doc) async {
              final group = GroupModel.fromMap(doc);

              // Fetch unreadCount from the members subcollection for this user
              final memberDoc =
                  await firestore
                      .collection('groups')
                      .doc(doc.id)
                      .collection('members')
                      .doc(userId)
                      .get();

              final unreadCount = memberDoc.data()?['unreadCount'] ?? 0;

              // Return GroupModel with unreadCount included
              return group.copyWith(unReadCount: unreadCount);
            }),
          );
        });
  }

  Future<void> resetGroupUnread(String groupId, String userId) async {
    await firestore
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .doc(userId)
        .update({'unreadCount': 0});
  }
}
