import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/config/router/app_router_notifier.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/products.dart';

  final goRouterProvider = Provider<GoRouter>((ref) {

    final goRouterNotifier = ref.read(goRouterNotifierProvider);

    return GoRouter(
      initialLocation: '/check-auth-status',
      //* cuando este cambia se recarga el redirect
      refreshListenable: goRouterNotifier, //* esta esperando un tipo ChangeNotifier (pendiente de cuando cambia la autehticacion, y se vuelve a evaluar el redirect)
      routes: [
        //* First Screen
        GoRoute(
          path: '/check-auth-status',
          builder: (context, state) => const CheckAutStatusScreen(),
        ),

        ///* Auth Routes
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),

        ///* Product Routes
        GoRoute(
          path: '/',
          builder: (context, state) => const ProductsScreen(),
        ),
      ],

      ///* Bloquear si no se está autenticado de alguna manera
      redirect: (context, state) {
        final isGoingTo =  state.subloc;
        final authStatus = goRouterNotifier.authStatus;
        // print(isGoingTo);
        // print(authStatus);
        if (isGoingTo == '/check-auth-status' && authStatus == AuthStatus.checking ) return null; 

        if ( authStatus == AuthStatus.notAuthenticate ) {
          if (isGoingTo == '/login' || isGoingTo == '/register') return null;
          return '/login';
        }

        if ( authStatus == AuthStatus.authenticated ) {
          if (isGoingTo == '/login' || isGoingTo == '/register' || isGoingTo == '/check-auth-status') return '/';
          return null;
        }
        
        return null;
      
        
      },
    );
  });