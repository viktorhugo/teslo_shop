
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:teslo_shop/features/auth/domain/entities/user.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

enum AuthStatus { checking, authenticated, notAuthenticate }

class AuthState {

  final AuthStatus authStatus;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.authStatus = AuthStatus.checking, 
    this.user, 
    this.errorMessage
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
  var logger = Logger();

  AuthNotifier({
    required this.authRepository 
  }): super(AuthState());
  
  Future<void> loginUser( { required String email, required String password }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final user = await authRepository.login(email: email, password: password);
      logger.i( user );
      _setLockUser(user);
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
      _setLockUser(user);
    } on WrongCredentials catch(e) {
      logger.e(e);
      logout('Wrong Credentials');
    } catch (e) {
      logout('Server error');
    }
  }

  void checkAuthStatus() async {

  }

  Future<void> logout([ String? errorMessage]) async {
    // Todo: Clean token
    state = state.copyWith(
      authStatus: AuthStatus.notAuthenticate,
      user: null,
      errorMessage: errorMessage
    );
  }

  void _setLockUser(User user) {
    // Todo: save token on movil
    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
    );
  }

}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImp();
  return AuthNotifier(authRepository: authRepository);
});