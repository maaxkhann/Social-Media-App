import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String senderId;
  final String text;
  final Timestamp timestamp;
  final bool read;

  ChatModel({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.read,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      read: map['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'read': read,
    };
  }
}
