import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media/models/user_model.dart';

class ReplyModel {
  final String replyId;
  final String commentId;
  final String reply;
  final String replyBy;
  final Timestamp timestamp;
  final bool isLiked;
  final UserModel? user;

  ReplyModel({
    required this.replyId,
    required this.commentId,
    required this.reply,
    required this.replyBy,
    required this.isLiked,
    required this.timestamp,
    this.user,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json, {UserModel? user}) {
    return ReplyModel(
      replyId: json['replyId'],
      commentId: json['commentId'],
      reply: json['reply'],
      replyBy: json['replyBy'],
      isLiked: json['isLiked'] ?? false,
      timestamp: json['timestamp'],
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'replyId': replyId,
      'commentId': commentId,
      'reply': reply,
      'replyBy': replyBy,
      'isLiked': isLiked,
      'timestamp': timestamp,
    };
  }
}
