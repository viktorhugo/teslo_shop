import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: GeometricalBackground( 
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80 ),
                // Icon Banner
                const Icon( 
                  Icons.production_quantity_limits_rounded, 
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox( height: 80 ),
    
                Container(
                  height: size.height - 260, // 80 los dos sizebox y 100 el ícono
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackgroundColor,
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(100)),
                  ),
                  child: const _LoginForm(),
                )
              ],
            ),
          )
        )
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget { //* Convertir en un ConsumerWidget (Propio de riverpod)
  const _LoginForm();                   //* PARA TENER ACCESO A TODOS LOS PROVIDER DE RIVERPOD

  @override
  Widget build(BuildContext context, WidgetRef ref) { //* Add WidgetRef ref (Propio de riverpod) 
    
    //* estar pendiente de los cambios (acceso al state)
    final loginForm = ref.watch(loginFormProvider);
    //* estar pendiente de los cambios (acceso al LoginFormNotifier)
    final loginFormNotifier = ref.read(loginFormProvider.notifier);

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox( height: 50 ),
          Text('Login', style: textStyles.titleLarge ),
          const SizedBox( height: 90 ),

          CustomTextFormField(
            label: 'Email',
            keyboardType: TextInputType.emailAddress,
            // onChanged: (value) => loginFormNotifier.onEmailChange(value),
            onChanged: loginFormNotifier.onEmailChange,
            errorMessage: loginForm.isFormPosted ? loginForm.email.errorMessage : null,
          ),
          const SizedBox( height: 30 ),

          CustomTextFormField(
            label: 'Password',
            obscureText: true,
            // onChanged: (value) => loginFormNotifier.onPasswordChange(value),
            onChanged: loginFormNotifier.onPasswordChange,
            errorMessage: loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          ),
    
          const SizedBox( height: 30 ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Signin',
              buttonColor: Colors.black,
              onPressed: () {
                loginFormNotifier.onSubmitForm();
              },
            )
          ),

          const Spacer( flex: 2 ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                onPressed: ()=> context.push('/register'), 
                child: const Text('Crea una aquí')
              )
            ],
          ),

          const Spacer( flex: 1),
        ],
      ),
    );
  }
}