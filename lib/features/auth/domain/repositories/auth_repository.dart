//* como quiero que sean todos los sistemas de auth 

import 'package:teslo_shop/features/auth/domain/domain.dart';

abstract class AuthRepository {

  Future<User> login(String email, String password);
  Future<User> register(String userName, String email, String password);
  Future<User> checkAuthStatus(String token);

}