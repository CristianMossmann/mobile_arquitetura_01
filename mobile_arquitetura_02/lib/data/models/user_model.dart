import 'package:mobile_arquitetura_01/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.firstName,
    required super.lastName,
    required super.image,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? 0) as int,
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      token: (json['accessToken'] ?? json['token'] ?? '').toString(),
    );
  }
}
