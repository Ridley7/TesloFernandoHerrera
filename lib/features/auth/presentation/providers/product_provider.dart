import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/presentation/providers/products_repository_provider.dart';
import 'package:teslo/features/products/domain/entities/product.dart';
import 'package:teslo/features/products/domain/respositories/products_repository.dart';

//3. Este es el provider
final productProvider = NotifierProvider.family<ProductNotifier, ProductState, String>(
  ProductNotifier.new
);

//2. Este es el notifier
class ProductNotifier extends Notifier<ProductState>{

  final String productId;
  late final ProductsRepository productsRepository;

  ProductNotifier(this.productId);


  @override
  ProductState build() {

    productsRepository = ref.watch(productsRepositoryProvider);

    //Aqui se ha de lanzar la carga del producto

    return ProductState(id: productId);
  }

}


//1. Este es el state
class ProductState{
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
    isSaving: isSaving ?? this.isSaving
  );
}