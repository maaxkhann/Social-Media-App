class NotificationModel {
  final String? notificationId;
  final String? senderId;
  final String? commentId;
  final String? senderName;
  final String? senderImage;
  final String? receiverId;
  final String? postId;
  final String? type; // like, comment, follow
  final String? message; // if type == comment
  final DateTime? timestamp;
  final bool? isRead;

  NotificationModel({
    this.notificationId,
    this.senderId,
    this.commentId,
    this.senderName,
    this.senderImage,
    this.receiverId,
    this.postId,
    this.type,
    this.message,
    this.timestamp,
    this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'],
      commentId: json['commentId'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
      receiverId: json['receiverId'],
      postId: json['postId'],
      type: json['type'],
      message: json['message'],
      isRead: json['isRead'],
      timestamp: (json['timestamp'])?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'notificationId': notificationId,
    'commentId': commentId,
    'senderId': senderId,
    'senderName': senderName,
    'senderImage': senderImage,
    'receiverId': receiverId,
    'type': type,
    'message': message,
    'timestamp': timestamp,
    'isRead': isRead,
  };
}
