import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/infrastructure/inputs/inputs.dart';

class ProductFormState {

  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final Stock inStock;
  final List<String> sizes;
  final String gender;
  final String description;
  final String tags;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false, 
    this.id, 
    this.title = const Title.dirty(''), 
    this.slug = const Slug.dirty(''), 
    this.price = const Price.dirty(0), 
    this.inStock = const Stock.dirty(0), 
    this.sizes = const [], 
    this.gender = 'men', 
    this.description = '', 
    this.tags = '', 
    this.images = const []
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    Stock? inStock,
    List<String>? sizes,
    String? gender,
    String? description,
    String? tags,
    List<String>? images,
  }) => ProductFormState(
    isFormValid: isFormValid ?? this.isFormValid,
    id: id ?? this.id,
    title: title ?? this.title,
    slug: slug ?? this.slug,
    price: price ?? this.price,
    inStock: inStock ?? this.inStock,
    sizes: sizes ?? this.sizes,
    gender: gender ?? this.gender,
    description: description ?? this.description,
    tags: tags ?? this.tags,
    images: images ?? this.images,
  );
}


class ProductFormNotifier extends StateNotifier<ProductFormState> {

  final Future<bool> Function( Map<String, dynamic> productLike )? onSubmitCallback;

  ProductFormNotifier({
    this.onSubmitCallback,
    required Product product
  }): super(
    ProductFormState(
      id: product.id,
      title: Title.dirty(product.title),
      slug: Slug.dirty(product.slug),
      price: Price.dirty(product.price),
      inStock: Stock.dirty(product.stock),
      sizes: product.sizes,
      gender: product.gender,
      description: product.description,
      tags: product.tags.join(','),
      images: product.images
    )
  );

  void onTitLeChange(String value) {
    state = state.copyWith(
      title: Title.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
    );
  }

  void onSlugChange(String value) {
    state = state.copyWith(
      slug: Slug.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.slug.value),
        Slug.dirty(value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
    );
  }

  void onPriceChange(double value) {
    state = state.copyWith(
      price: Price.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.slug.value),
        Slug.dirty(state.slug.value),
        Price.dirty(value),
        Stock.dirty(state.inStock.value),
      ])
    );
  }

  void onStockChange(int value) {
    state = state.copyWith(
      inStock: Stock.dirty(value),
      isFormValid: Formz.validate([
        Title.dirty(state.slug.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(value),
      ])
    );
  }
  
  void onSizesChange(List<String> sizes) {
    state = state.copyWith(
      sizes: sizes
    );
  }

  void onGenderChange(String gender) {
    state = state.copyWith(
      gender: gender
    );
  }

  void onDescriptionChange(String description) {
    state = state.copyWith(
      description: description
    );
  }

  void onTagsChange(String tags) {
    state = state.copyWith(
      tags: tags
    );
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.slug.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ])
    );
  }

  Future<bool> onSubmitForm() async {
    _touchedEverything();
    print('isFormValid ${state.isFormValid}');
    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;
    
    final productLike = {
      'id': state.id == 'new' ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.sizes,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images.map(
        (image) => image.replaceAll('${Environment.apiurl}/files/product/', '')
      ).toList()
    };
    // print(productLike);
    try {
      return await onSubmitCallback!(productLike);
    } catch (e) {
      return false;
    }
  }

  void updatedProductImage(String imagePath) {
    state = state.copyWith(
      images: [...state.images, imagePath]
    );
  }
}

//* el autodispose es para que se limpie cuando no se nesecita
//* family por que se nesecita enviar el tipo de dato para poder crear el provider (product)
final productFormProvider = StateNotifierProvider.autoDispose.family<ProductFormNotifier, ProductFormState, Product>(
  (ref, product) {  
  
    //* este method es el que vamos a utilizar cuando el formulario es valido
    final createUpdateProductCallback = ref.watch(productsProvider.notifier).createOrUpdateProduct;

    return ProductFormNotifier(
      product: product,
      onSubmitCallback: createUpdateProductCallback, // function to save data (product)
    );
  }
);