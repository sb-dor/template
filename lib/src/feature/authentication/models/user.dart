// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String id;
  final String email;

  const User({required this.id, required this.email});

  User copyWith({String? id, String? email}) {
    return User(id: id ?? this.id, email: email ?? this.email);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'email': email};
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(id: map['id'] as String, email: map['email'] as String);
  }

  @override
  String toString() => 'User(id: $id, email: $email)';

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id && other.email == email;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
