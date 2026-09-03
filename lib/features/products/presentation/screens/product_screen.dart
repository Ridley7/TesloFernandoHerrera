import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/presentation/providers/product_provider.dart';

class ProductScreen extends ConsumerWidget {
  const ProductScreen({
    super.key,
    required this.productId
  });

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final product = ref.watch(productProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar producto"),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.camera_alt_outlined)
          )
        ],
      ),

      body:Center(
        child: Text(product.product?.title ?? "Cargando"),
      ),
      
      floatingActionButton: FloatingActionButton(
          onPressed: (){},
        child: const Icon( Icons.save_as_outlined),
      ),
    );
  }
}
