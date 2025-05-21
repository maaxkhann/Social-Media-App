import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class PostModel {
  final String postId;
  final String mediaUrl;
  final String text;
  final String userId;
  final String postType;
  final bool isLiked;
  final Timestamp timestamp;
  final UserModel? user;

  PostModel({
    required this.postId,
    required this.mediaUrl,
    required this.text,
    required this.userId,
    required this.postType,
    required this.timestamp,
    required this.isLiked,
    this.user,
  });

  factory PostModel.fromJson(Map<String, dynamic> doc, {UserModel? user}) {
    final data = doc;

    return PostModel(
      postId: data['postId'],
      mediaUrl: data['mediaUrl'],
      text: data['text'],
      userId: data['userId'],
      postType: data['postType'],
      isLiked: data['isLiked'],
      timestamp: data['timestamp'],
      user: user,
    );
  }
}
