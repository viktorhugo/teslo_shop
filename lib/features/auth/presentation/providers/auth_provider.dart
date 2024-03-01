
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

enum AuthStatus { checking, authenticated, notAuthenticate }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage = ''
  });

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) => AuthState(
    authStatus: authStatus ?? this.authStatus,
    errorMessage: errorMessage ?? this.errorMessage,
    user: user ?? this.user
  );
}

class AuthNotifier extends StateNotifier<AuthState> {

  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  var logger = Logger();

  AuthNotifier({
    required this.authRepository,
    required this.keyValueStorageService,
  }): super(AuthState()) {
    //* revisar si existe el token y validarlo
    checkAuthStatus();
  }
  
  Future<void> loginUser( { required String email, required String password }) async {
    // await Future.delayed(const Duration(milliseconds: 1500));
    try {
      final user = await authRepository.login(email: email, password: password);
      // logger.i( { user.email, user.fullName, user.id, user.token, user.roles} );
      _setLoggedUser(user);
    } on CustomError catch(e) {
      logger.e(e.message);
      logout(e.message);
    } catch (e) {
      logger.e(e);
      logout('Internal Server error');
    }
  }

  void registerUser( { required String userName, required String email, required String password }) async {
    // await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.register(
        email: email,
        password: password,
        userName: userName
      );
      _setLoggedUser(user);
    } on WrongCredentials catch(e) {
      logger.e(e);
      logout('Wrong Credentials');
    } catch (e) {
      logout('Server error');
    }
  }

  void checkAuthStatus() async {
    // * get token
    final token = await keyValueStorageService.getValue<String>('x-token');
    if (token == null) return logout();

    try {
      //* get new token for the session and User
      final user = await authRepository.checkAuthStatus(token: token);
      //* update state
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  Future<void> logout([ String? errorMessage]) async {
    //* remove token 
    await keyValueStorageService.removeKey('x-token');
    //* update status
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticate,
      user: null,
      errorMessage: errorMessage
    );
  }

  void _setLoggedUser(User user) async {
    //* save token 
    await keyValueStorageService.setKeyValue('x-token', user.token);
    //* update status
    state = state.copyWith(
      user: user,
      errorMessage: '',
      authStatus: AuthStatus.authenticated,
    );
    // print('set state');
  }

}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImp();
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService
  );
});