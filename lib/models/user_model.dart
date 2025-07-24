class UserModel {
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? position;
  final String? image;
  final String? fcmToken;
  final bool? isOnline;

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.position,
    this.image,
    this.fcmToken,
    this.isOnline,
  });

  factory UserModel.fromJson(Map<String, dynamic> doc) {
    final data = doc;

    return UserModel(
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      position: data['position'] ?? '',
      image: data['image'] ?? '',
      fcmToken: data['fcmToken'] ?? '',
      isOnline: data['isOnline'] ?? false,
    );
  }
}
