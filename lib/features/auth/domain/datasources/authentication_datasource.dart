import 'package:teslo/features/auth/domain/entities/user.dart';

abstract class AuthenticationDatasource {

  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String fullName);
  Future<User> checkAuthStatus(String token);

}