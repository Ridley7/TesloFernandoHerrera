import 'package:teslo/features/auth/domain/datasources/authentication_datasource.dart';
import 'package:teslo/features/auth/domain/entities/user.dart';
import 'package:teslo/features/auth/domain/repositories/authentication_repository.dart';
import 'package:teslo/features/auth/infrastructure/datasources/authentication_datasource_implementation.dart';

class AuthenticationRepositoryImplementation extends AuthenticationRepository{

  final AuthenticationDatasource datasource;

  AuthenticationRepositoryImplementation({
    AuthenticationDatasource? datasource
  }) : datasource = datasource ?? AuthenticationDatasourceImplementation();



  @override
  Future<User> checkAuthStatus(String token) {
    return datasource.checkAuthStatus(token);
  }

  @override
  Future<User> login(String email, String password) {
    return datasource.login(email, password);
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    return datasource.register(email, password, fullName);
  }

}