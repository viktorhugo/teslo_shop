//* mandar hace los cambios de los datasources



import 'package:teslo_shop/features/auth/domain/domain.dart';

import '../datasources/auth_datasource_imp.dart';

class AuthRepositoryImp extends AuthRepository {

  final AuthDataSource dataSource;

  AuthRepositoryImp({ 
    AuthDataSource? dataSource
  }) : dataSource = dataSource ?? AuthDataSourceImp();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return dataSource.login(email, password);
  }

  @override
  Future<User> register(String userName, String email, String password) {
    return dataSource.register(userName, email, password);
  }


}