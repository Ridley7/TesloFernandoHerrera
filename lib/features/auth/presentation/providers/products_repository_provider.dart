import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/products/infrastructure/datasources/products_datasource_implementation.dart';
import 'package:teslo/features/products/infrastructure/repositories/products_repository_implementation.dart';
import 'package:teslo/presentation/providers/authentication_provider.dart';

final productRepositoryProvider = Provider((ref){
  
  final token = ref.watch(authenticationProvider).user?.token ?? ' ';
  
  return ProductsRepositoryImplementation(
      datasource: ProductsDatasourceImplementation(
        accessToken: token
      )
  );
});