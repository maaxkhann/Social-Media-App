import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_model.dart';

class CommentsModel {
  final String commentId;
  final String postId;
  final String comment;
  final String commentBy;
  final bool isLiked;
  final Timestamp timeStamp;
  final CommentsModel? commentReply; // nested reply
  final UserModel? user;

  CommentsModel({
    required this.commentId,
    required this.postId,
    required this.comment,
    required this.commentBy,
    required this.isLiked,
    required this.timeStamp,
    this.commentReply,
    this.user,
  });

  factory CommentsModel.fromJson(Map<String, dynamic> doc, {UserModel? user}) {
    return CommentsModel(
      commentId: doc['commentId'],
      postId: doc['postId'],
      comment: doc['comment'],
      commentBy: doc['commentBy'],
      isLiked: doc['isLiked'] ?? false,
      timeStamp: doc['timeStamp'],
      commentReply:
          doc['commentReply'] != null
              ? CommentsModel.fromJson(doc['commentReply'])
              : null,
      user: user,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'postId': postId,
      'comment': comment,
      'commentBy': commentBy,
      'isLiked': isLiked,
      'timeStamp': timeStamp,
      'commentReply': commentReply?.toJson(),
    };
  }
}
