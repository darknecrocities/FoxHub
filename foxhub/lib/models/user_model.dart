// lib/models/user_model.dart

class UserModel {
  String uid; // make it non-final and mutable
  final String fullName;
  final String username;
  final String email;
  final String course;
  final String number;

  UserModel({
    this.uid = '', // default empty string, mutable
    required this.fullName,
    required this.username,
    required this.email,
    required this.course,
    required this.number,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'fullName': fullName,
      'username': username,
      'email': email,
      'course': course,
      'number': number,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      course: map['course'] ?? '',
      number: map['number'] ?? '',
    );
  }
}
