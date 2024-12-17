import 'package:blog_app/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.id,
    required super.name,
  });
  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      email: map["map"] ?? "",
      id: map["id"] ?? "",
      name: map["name"] ?? "",
    );
  }
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
  }) {
    return UserModel(
      email: email ?? this.email,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
