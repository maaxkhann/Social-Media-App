import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String position;
  final String image;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> doc) {
    final data = doc;

    return UserModel(
      userId: data['userId'],
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      position: data['position'],
      image: data['image'],
    );
  }
}
