import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/products/presentation/providers/providers.dart';

class ProductScreen extends ConsumerWidget {

  final String productId;

  const ProductScreen({
    super.key, 
    required this.productId
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final productState = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: () {

            }, 
            icon: const Icon(Icons.camera_enhance_rounded, size: 30,)
          )
        ],
      ),
      body: const Center(
        child: Text('test')
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
        },
        child: const Icon(Icons.save_as_rounded, size: 30,),
      ),
    );
  }
}