import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/presentation/providers/products_repository_provider.dart';
import 'package:teslo/features/products/domain/entities/product.dart';
import 'package:teslo/features/products/domain/respositories/products_repository.dart';

//Este es el provider
final productsProvider = NotifierProvider<ProductNotifier, ProductState>(
  ProductNotifier.new
);

//Este es el notifier
class ProductNotifier extends Notifier<ProductState>{

  late final ProductsRepository productsRepository;

  @override
  ProductState build() {

    productsRepository = ref.watch(productRepositoryProvider);

    // carga automática al crear el provider
    Future.microtask(() => loadNextPage());

    return ProductState();

  }

  Future<void> loadNextPage() async {

    //Evitamos mas solicitudes
    if( state.isLoading || state.isLastPage) return;

    //Indicamos que estamos procesando datos
    state = state.copyWith(
      isLoading: true
    );

    //Solicitamos los productos al backend
    final List<Product> products = await productsRepository
        .getProductsByPage(limit: state.limit, offset: state.offset);

    //Indicamos nuevo esados de los productos
    if(products.isEmpty){
      state = state.copyWith(
        isLoading: false,
        isLastPage: true
      );

      return;
    }

    //Si la lista de productos tiene contenido la pasamos al state
    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products, ...products]
    );

  }


}

//Este es el state
class ProductState{
    final bool isLastPage;
    final int limit;
    final int offset;
    final bool isLoading;
    final List<Product> products;

  ProductState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const []
  });

  ProductState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products
  );
}