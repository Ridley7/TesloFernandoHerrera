import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/presentation/providers/products_repository_provider.dart';
import 'package:teslo/features/products/domain/entities/product.dart';
import 'package:teslo/features/products/domain/respositories/products_repository.dart';

//Este es el provider
final productsProvider = NotifierProvider<ProductsNotifier, ProductsState>(
  ProductsNotifier.new
);

//Este es el notifier
class ProductsNotifier extends Notifier<ProductsState>{

  late final ProductsRepository productsRepository;

  @override
  ProductsState build() {

    productsRepository = ref.watch(productsRepositoryProvider);

    // carga automática al crear el provider
    Future.microtask(() => loadNextPage());

    return ProductsState();

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
class ProductsState{
    final bool isLastPage;
    final int limit;
    final int offset;
    final bool isLoading;
    final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const []
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products
  );
}