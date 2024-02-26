//* objetivo de este provider
//* poder establecer a lo largo de toda mi aplicacion al instancia de el ProductRepositoryImpl

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/infrastructure/infrastructure.dart';


//* se pueden hablar entre providers mediante el ref (arboles de providers)
final productsRepositoryProvider = Provider<ProductsRepository>((ref) {

  //* cualquier cambio en el authProvider tambien actualiza aca fuese login o register o logout
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productsRepository = ProductsRepositoryImpl(
    dataSource: ProductsDatasourceImpl(accessToken: accessToken)
  );

  return productsRepository;
});