import 'package:teslo_shop/features/auth/infrastructure/entities/user.dart';

class UserMapper {
  
  static User userJsonToEntity(Map<String, dynamic> json) => User(
    id: json['id'], 
    email: json['email'], 
    userName: json['userName'], 
    roles: List<String>.from(json['roles'].map( (role) => role)), 
    token: json['token']
  );

}