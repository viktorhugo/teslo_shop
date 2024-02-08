//* IMPLEMENTACION DEL TODO EL PROCESO

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:teslo_shop/config/enviroment/enviroment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImp extends AuthDataSource {

  final dio = Dio(
    BaseOptions(
      baseUrl: Enviroment.apiurl
    )
  );

  @override
  Future<User> checkAuthStatus(String token) {
    // TODO: implement checkAuthStatus
    throw UnimplementedError();
  }

  @override
  Future<User> login(String email, String password) async {
    
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } catch (e) {
      WrongCredentials();
    }
  }

  @override
  Future<User> register(String userName, String email, String password) async {
    
    try {
      final response = await dio.post('/auth/register', data: {
        'userName': userName,
        'email': email,
        'password': password
      });
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } catch (e) {
      WrongCredentials();
    }
  }

}