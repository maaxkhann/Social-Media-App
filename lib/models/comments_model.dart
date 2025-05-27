import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class CommentsModel {
  final String commentId;
  final String postId;

  final String comment;
  final String commentBy;
  final bool isLiked;

  final Timestamp timeStamp;
  final UserModel? user;

  CommentsModel({
    required this.commentId,
    required this.postId,

    required this.comment,
    required this.commentBy,
    required this.isLiked,

    required this.timeStamp,
    this.user,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> doc, {UserModel? user}) {
    final data = doc;

    return CommentsModel(
      commentId: data['commentId'],
      postId: data['postId'],

      comment: data['comment'],
      commentBy: data['commentBy'],
      isLiked: data['isLiked'],

      timeStamp: data['timeStamp'],
      user: user,
    );
  }
}
