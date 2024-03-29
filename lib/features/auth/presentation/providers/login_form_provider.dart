import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:logger/logger.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

var logger = Logger();
//! 1 -State del provider

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  LoginFormState({
    this.isPosting = false, 
    this.isFormPosted = false, 
    this.isValid = false, 
    this.email = const Email.pure(), 
    this.password = const Password.pure()
  });

  // copy 
  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => LoginFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );

  @override
  String toString() {
    return '''
      LoginFormState:
        isPosting: $isPosting,
        isFormPosted: $isFormPosted,
        isValid: $isValid,
        email: $email,
        password: $password,
    ''';
  }
}

//! 2 -como implementamos un notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {

  final  Function({ required String email,  required String password}) loginUserCallback;

  LoginFormNotifier({
    required this.loginUserCallback
  }): super(
    LoginFormState() ///* CREACION DEL ESTADO INICIAL
  );

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.password ])
    ); 
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email ])
    );
  }

  onSubmitForm() async {
    _touchEveryFiled();
    //* SI NO SON VALIDOS LOS FIELDS NO HAGA NADA
    if ( !state.isValid ) return;

    state = state.copyWith( isPosting: true );

    await loginUserCallback(email: state.email.value, password: state.password.value);
    
    state = state.copyWith( isPosting: false );
    // logger.d("State: $state");
    // print(state);

  }

  _touchEveryFiled(){
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([ email, password ])
    );
  }
  
}

//! 3 -StateNotifierProvider - consume afuera
final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) { //* se coloca el autoDispose para que cuando se
  final loginUserCallback = ref.watch(authProvider.notifier).loginUser;
  return LoginFormNotifier(loginUserCallback: loginUserCallback);                                                                       //* que cuando se salga de la pantalla y vuelca no esten los datos del login
});