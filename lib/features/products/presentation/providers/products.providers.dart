
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_repository_provider.dart';

//* STATE notifier provider 
class ProductsState {
  
  final bool isLastPage;
  final bool isLoading;
  final int limit;
  final int offset;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false, 
    this.isLoading = false, 
    this.limit = 10, 
    this.offset = 0, 
    this.products = const[]
  });

  ProductsState copyWith({
    bool? isLastPage,
    bool? isLoading,
    int? limit,
    int? offset,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    isLoading: isLoading ?? this.isLoading,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    products: products ?? this.products,
  );

    @override
  String toString() {
    return '''
      productsState:
        isLastPage: $isLastPage,
        isLoading: $isLoading,
        limit: $limit,
        offset: $offset,
        products: $products,
    ''';
  }

}

//* state NOTIFIER provider 

class ProductsNotifier extends StateNotifier<ProductsState> {

  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository
  }): super( ProductsState() ) { //* el estado inicial ProductsState 
    //* Cuando se cree la primera instancia del ProductsNotifier en cualquier lugar llama la function loadNextPage
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createUpdateProduct(productLike);
      // check product exists in list
      final isProductAlreadyExists = state.products.any((element) => element.id == product.id);
      // si no existe el producto se guarda
      if (!isProductAlreadyExists) {
        state = state.copyWith(
          products: [...state.products, product]
        );
        return true;
      } else {
        // update product
        state = state.copyWith(
          products: state.products.map(
            (element) => (element.id == product.id) ? product : element
          ).toList()
        ); 
        return true;
      }
      
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {

    if (state.isLoading || state.isLastPage) return;
    
    state = state.copyWith( isLoading: true );

    final products = await productsRepository.getProductsByPage(limit: state.limit, offset: state.offset);

    if (products.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true
      );
      return;
    }
    // update
    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products]
    ); 
  }
  
}

//* Provee el state de manera global
//* este provider va tener sus methods (ProductsNotifier) y su estado (ProductsState)
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {

  final ProductsRepository productsRepository = ref.watch(productsRepositoryProvider);

  //* inicializa el ProductsNotifier
  return ProductsNotifier( productsRepository: productsRepository );
});

