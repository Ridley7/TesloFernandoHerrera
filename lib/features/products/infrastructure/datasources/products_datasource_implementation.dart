import 'package:dio/dio.dart';
import 'package:teslo/config/constants/environment.dart';
import 'package:teslo/features/products/domain/datasources/products_datasource.dart';
import 'package:teslo/features/products/domain/entities/product.dart';
import 'package:teslo/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImplementation extends ProductsDatasource {

  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImplementation({
    required this.accessToken
  }) : dio = Dio (
    BaseOptions(
      baseUrl: Environment.baseUrl,
      headers: {
        'Authorization': 'Bearer $accessToken'
      }
    )
  );


  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) {
    // TODO: implement getProductById
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async {

    final response = await dio.get('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];

    for(final product in response.data ?? []){
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;

  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }



}