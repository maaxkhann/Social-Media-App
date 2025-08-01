import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessagesModel {
  final String? id;
  final List<String>? readBy;
  final String? senderId;
  final String? senderImage;
  final String? senderName;
  final String? text;
  final DateTime? timeStamp;
  final String? voiceUrl;

  GroupMessagesModel({
    this.id,
    this.readBy,
    this.senderId,
    this.senderImage,
    this.senderName,
    this.text,
    this.timeStamp,
    this.voiceUrl,
  });

  factory GroupMessagesModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return GroupMessagesModel(
      id: doc.id,
      readBy: List<String>.from(data['readBy'] ?? []),
      senderId: data['senderId'],
      senderImage: data['senderImage'],
      senderName: data['senderName'],
      text: data['text'],
      timeStamp:
          (data['timeStamp'] is Timestamp)
              ? (data['timeStamp'] as Timestamp).toDate()
              : null,
      voiceUrl: data['voiceUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'readBy': readBy,
      'senderId': senderId,
      'senderImage': senderImage,
      'senderName': senderName,
      'text': text,
      'timeStamp': timeStamp,
      'voiceUrl': voiceUrl,
    };
  }
}
