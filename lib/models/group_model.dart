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
    this.unReadCount = 0,
  });

  factory GroupModel.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GroupModel(
      id: doc.id,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      members: List<String>.from(data['members'] ?? []),
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'createdAt': createdAt, 'members': members, 'name': name};
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
