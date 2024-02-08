
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/repositories/auth_repository.dart';
import 'package:teslo_shop/features/auth/infrastructure/entities/user.dart';
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

  AuthNotifier({
    required this.authRepository 
  }): super(AuthState());
  
  void loginUser( String email, String password) async {
    
  }
  void registerUser( String userName, String email, String password) async {

  }
  void checkAuthStatus() async {

  }
  Future<void> logout() async {

  }

}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {

  final authRepository = AuthRepositoryImp();
  return AuthNotifier(authRepository: authRepository);
});