import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';


  // ESTO ES COMO VAMOS A PROVEER ESTE NOFIFIER PROVIDER
  final goRouterNotifierProvider = Provider((ref) {
    //* va utizar la misma instancia
    final authNotifier = ref.read(authProvider.notifier);
    return GoRouterNotifier(authNotifier);
  });

class GoRouterNotifier extends ChangeNotifier {
  //* es la instancia que controlla el estado de la autenticacion
  final AuthNotifier _authNotifier;
  
  AuthStatus _authStatus = AuthStatus.checking;

  GoRouterNotifier( this._authNotifier ){
    //* en todo de mi aplicacion nesecito estar atento de los cambios que tenga el _authNotifier( cambio en el state )
    //* osea nos suscribimos a ese gestor de estado para cambiar el _authState
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
    });
  }

  AuthStatus get authStatus => _authStatus;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

}

//* cunado yo cambie el authStatus imediatamente va notificar a mi router