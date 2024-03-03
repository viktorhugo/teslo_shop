import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/domain/domain.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductScreen extends ConsumerWidget {

  final String productId;

//* notifications when save product
  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product updated', style: TextStyle(fontSize: 18),),
            SizedBox(width: 10,),
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 25,),
          ],
        )
      )
    );
  }

  const ProductScreen({
    super.key, 
    required this.productId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    //* este producto no va cambiar hasta que salga y vuelve a entrar (se dispara en autodispose y limpia el product)
    final productState = ref.watch(productProvider(productId));

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Product'),
          actions: [

            IconButton(
              onPressed: () async {
                final photoPath = await CameraGalleryServiceImpl().selectPhoto();
                if (photoPath == null) return;
                ref.read(productFormProvider(productState.product!).notifier).updatedProductImage(photoPath);
                print(photoPath);
              }, 
              icon: const Icon(Icons.photo_library_outlined, size: 30,)
            ),

            IconButton(
              onPressed: () async {
                final photoPath = await CameraGalleryServiceImpl().takePhoto();
                if (photoPath == null) return;
                ref.read(productFormProvider(productState.product!).notifier).updatedProductImage(photoPath);
                print(photoPath);
              }, 
              icon: const Icon(Icons.camera_enhance_rounded, size: 30,)
            )
          ],
        ),
        
        body: productState.isLoading
          ? const FullScreenLoader()
          : _ProductView(product: productState.product!),
      
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (productState.product == null) return;
            final provider = ref.read(productFormProvider( productState.product! ).notifier);
            provider.onSubmitForm().then(
              (value) {
                if (value) {
                  showSnackbar(context);
                }
              }
            );
          },
          child: const Icon(Icons.save_as_rounded, size: 30,),
        ),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {

  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final textStyles = Theme.of(context).textTheme;
    
    //* init provider productFormProvider
    final productFormPro = ref.watch( productFormProvider( product ));

    return ListView(
      children: [

        //* gallery images
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productFormPro.images ),
        ),
  
        const SizedBox( height: 10 ),

        //* Name Product
        Center(child: Text( 
          productFormPro.title.value, 
          style: textStyles.titleSmall,
          textAlign: TextAlign.center,
        )),

        const SizedBox( height: 10 ),

        //* Product Information
        _ProductInformation( product: product ),
        
      ],
    );
  }
}


class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref ) {

    final productFormPro = ref.watch( productFormProvider( product ));
    final productNotifier = ref.read(productFormProvider(product).notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //* Generals
          const Text('Generals'),
          const SizedBox(height: 15 ),
          CustomProductField( 
            isTopField: true,
            label: 'Name',
            initialValue: productFormPro.title.value,
            onChanged: (value) => productNotifier.onTitLeChange(value),
            errorMessage: productFormPro.title.errorMessage,
          ),
          CustomProductField( 
            label: 'Slug',
            initialValue: productFormPro.slug.value,
            onChanged: (value) => productNotifier.onSlugChange(value),
            errorMessage: productFormPro.slug.errorMessage,
          ),
          CustomProductField( 
            isBottomField: true,
            label: 'Price',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormPro.price.value.toString(),
            onChanged: (value) => productNotifier.onPriceChange(double.tryParse(value) ?? -1),
            errorMessage: productFormPro.price.errorMessage,
          ),

          const SizedBox(height: 15 ),
          
          
          const Text('Extras'),

          //* Sizes
          _SizeSelector(
            selectedSizes: productFormPro.sizes, 
            onSizesChange: productNotifier.onSizesChange
          ),

          const SizedBox(height: 5 ),

          //* Gender
          _GenderSelector( 
            selectedGender: productFormPro.gender,
            onGenderChange: productNotifier.onGenderChange
          ),
          
          const SizedBox(height: 15 ),
          
          //* Existential
          CustomProductField( 
            isTopField: true,
            label: 'Existential',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productFormPro.inStock.value.toString(),
            onChanged: (value) => productNotifier.onStockChange(int.tryParse(value) ?? -1),
            errorMessage: productFormPro.inStock.errorMessage,
          ),

          //* Description
          CustomProductField( 
            maxLines: 6,
            label: 'Description',
            keyboardType: TextInputType.multiline,
            initialValue: product.description,
            onChanged: (value) => productNotifier.onDescriptionChange(value),
          ),

          CustomProductField( 
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separated by coma)',
            keyboardType: TextInputType.multiline,
            initialValue: product.tags.join(', '),
            onChanged: (value) => productNotifier.onTagsChange(value),
          ),

          const SizedBox(height: 100 ),
        ],
      ),
    );
  }
}


class _SizeSelector extends StatelessWidget {
  
  final List<String> selectedSizes;
  final List<String> sizes = const['XS','S','M','L','XL','XXL','XXXL'];
  final void Function(List<String> selectedSizes) onSizesChange;

  const _SizeSelector({
    required this.selectedSizes, 
    required this.onSizesChange
  });


  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      showSelectedIcon: false,
      emptySelectionAllowed: true,
      segments: sizes.map((size) {
        return ButtonSegment(
          value: size, 
          label: Text(size, style: const TextStyle(fontSize: 10))
        );
      }).toList(), 
      selected: Set.from( selectedSizes ),
      onSelectionChanged: (newSelection) {
        FocusScope.of(context).unfocus();
        onSizesChange(List.from(newSelection));
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const['men','women','kid'];
  final List<IconData> genderIcons = const[
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];
  final void Function(String selectedGenders) onGenderChange;


  const _GenderSelector({
    required this.selectedGender, 
    required this.onGenderChange
  });


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        emptySelectionAllowed: false,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact ),
        segments: genders.map((size) {
          return ButtonSegment(
            icon: Icon( genderIcons[ genders.indexOf(size) ] ),
            value: size, 
            label: Text(size, style: const TextStyle(fontSize: 12))
          );
        }).toList(), 
        selected: { selectedGender },
        onSelectionChanged: (newSelection) {
          FocusScope.of(context).unfocus();
          print(newSelection);
          if (newSelection.isNotEmpty) {
            final selectedGender = newSelection.first;
            return onGenderChange(selectedGender);
          } else {
            return onGenderChange('men');
          }
        },
      ),
    );
  }
}


class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Image.asset('assets/images/no-image.jpg', fit: BoxFit.cover )
      );
    }

    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(
        viewportFraction: 0.7
      ),
      children: images.map((image){

        late ImageProvider imageProvider;
        if (image.startsWith('http')) {
          imageProvider = NetworkImage(image);
        } else {
          // final checkFile = File(image).existsSync();
          // if (!checkFile) return;
          imageProvider = FileImage(File(image));
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholder: const AssetImage('assets/loaders/bottle-loader.gif'), 
              image: imageProvider
            )
          ),
        );
      }).toList(),
    );
  }
}