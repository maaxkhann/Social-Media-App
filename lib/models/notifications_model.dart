class NotificationModel {
  final String? id;
  final String? senderId;
  final String? senderName;
  final String? senderImage;
  final String? receiverId;
  final String? type; // like, comment, follow
  final String? comment; // if type == comment
  final DateTime? timestamp;

  NotificationModel({
    this.id,
    this.senderId,
    this.senderName,
    this.senderImage,
    this.receiverId,
    this.type,
    this.comment,
    this.timestamp,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      senderId: json['senderId'],
      senderName: json['senderName'],
      senderImage: json['senderImage'],
      receiverId: json['receiverId'],
      type: json['type'],
      comment: json['comment'],
      timestamp: (json['timestamp'])?.toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'senderImage': senderImage,
    'receiverId': receiverId,
    'type': type,
    'comment': comment,
    'timestamp': timestamp,
  };
}
