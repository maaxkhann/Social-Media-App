import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final DateTime createdAt;
  final List<String> members;
  final String name;
  final int unReadCount; // ✅ Added unread count

  GroupModel({
    required this.id,
    required this.createdAt,
    required this.members,
    required this.name,
    required this.unReadCount,
  });

  factory GroupModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroupModel(
      id: doc.id,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      members: List<String>.from(data['members'] ?? []),
      name: data['name'] ?? '',
      unReadCount: data['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'members': members,
      'name': name,
      'unreadCount': unReadCount,
    };
  }

  GroupModel copyWith({int? unReadCount}) {
    return GroupModel(
      id: id,
      createdAt: createdAt,
      members: members,
      name: name,
      unReadCount: unReadCount ?? this.unReadCount,
    );
  }
}
