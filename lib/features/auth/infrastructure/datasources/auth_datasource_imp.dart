//* IMPLEMENTACION DEL TODO EL PROCESO

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:teslo_shop/config/enviroment/enviroment.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImp extends AuthDataSource {
  
  var logger = Logger();

  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiurl
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final Options options = Options(
        headers: {
          'Authorization' : 'Bearer $token'
        }
      );
      final response = await dio.get('/auth/check-status', options: options );
      // logger.i(response);
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(message: 'Wrong Credentials');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Connection Timeout');
      }
      logger.e(e.response!.data['message']);
      throw Exception();
    } catch (e) {
      logger.e(e);
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });
      // logger.i(response);
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(message: e.response!.data['message'] ?? 'Wrong Credentials');
      }
      if (e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(message: 'Connection Timeout');
      }
      logger.e(e.response!.data['message']);
      throw Exception();
    } catch (e) {
      logger.e(e);
      throw Exception();
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
      logger.e(e);
      throw WrongCredentials();
    }
  }

}