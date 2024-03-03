


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id, 
    this.product, 
    this.isLoading = true, 
    this.isSaving = false
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );
}

class ProductNotifier extends StateNotifier<ProductState> {

  final ProductsRepository productsRepository;
  final String productId;

  ProductNotifier({
    required this.productsRepository,
    required this.productId,
  }): super(
    ProductState(id: productId)
  ){
    getProduct();
  }

  Product newEmptyProduct() {
    return Product(
      id: 'new', 
      title: '', 
      price: 0, 
      description: '', 
      slug: '', 
      stock: 0, 
      sizes: [], 
      gender: 'men', 
      tags: [], 
      images: [], 
    );
  }

  Future<void> getProduct() async {
    print(state.id == 'new');
    if (state.id == 'new') {
      state = state.copyWith(
        isLoading: false,
        product: newEmptyProduct()
      );
      return;
    }
    final product = await productsRepository.getProductById(id: state.id);
    state = state.copyWith(
      isLoading: false,
      product: product
    );
  }
  
}

//* el auto dispose para que se limpie cuando no se cierra el screen del product
//* y el family esperar(productId) un valor a la hora de utilizar este provider
final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier, ProductState, String>((ref, productId) {

  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
    productId: productId,
    productsRepository: productsRepository
  );
});