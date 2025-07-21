import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/models/user_model.dart';

class ChatUserModel {
  final String otherUserId;
  final String lastMessage;
  final DateTime? lastMessageTimestamp;
  final bool isGroup;
  final int unreadCount;

  final UserModel? user;

  ChatUserModel({
    required this.otherUserId,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.isGroup,
    required this.unreadCount,

    this.user,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json, {UserModel? user}) {
    return ChatUserModel(
      otherUserId: json['otherUserId'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTimestamp:
          json['lastMessageTimestamp'] != null
              ? (json['lastMessageTimestamp'] as Timestamp).toDate()
              : null,
      unreadCount: 0, // default
      isGroup: json['isGroup'] ?? false,
      user: user,
    );
  }

  ChatUserModel copyWith({int? unreadCount}) {
    return ChatUserModel(
      otherUserId: otherUserId,
      lastMessage: lastMessage,
      lastMessageTimestamp: lastMessageTimestamp,
      unreadCount: unreadCount ?? this.unreadCount,
      user: user,
      isGroup: isGroup,
    );
  }
}
