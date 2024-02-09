//* como quiero que sean todos los sistemas de auth 

import 'package:teslo_shop/features/auth/domain/domain.dart';

abstract class AuthRepository {

  Future<User> login({ required String email, required String password});
  Future<User> register({ required String userName, required String email, required String password });
  Future<User> checkAuthStatus({ required String token });

}