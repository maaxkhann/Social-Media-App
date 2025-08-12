import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String senderId;
  final String id;
  final String text;
  final String? voiceUrl;
  final Timestamp timestamp;
  final bool read;

  ChatModel({
    required this.senderId,
    required this.id,
    required this.text,
    this.voiceUrl,
    required this.timestamp,
    required this.read,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      senderId: map['senderId'] ?? '',
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      voiceUrl: map['voiceUrl'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      read: map['read'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'id': id,
      'text': text,
      'voiceUrl': voiceUrl,
      'timestamp': timestamp,
      'read': read,
    };
  }
}
