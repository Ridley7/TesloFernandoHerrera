import 'package:dio/dio.dart';
import 'package:teslo/config/constants/environment.dart';
import 'package:teslo/features/auth/domain/datasources/authentication_datasource.dart';
import 'package:teslo/features/auth/domain/entities/user.dart';
import 'package:teslo/features/auth/infrastructure/errors/custom_error.dart';
import 'package:teslo/features/auth/infrastructure/mappers/user_mapper.dart';

class AuthenticationDatasourceImplementation extends AuthenticationDatasource{

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
    )
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try{
      final response = await dio.get('/auth/check-status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token'
          }
        )
      );
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e){

      if( e.response?.statusCode == 401){
        throw CustomError('Token incorrecto');
      }

      throw Exception();

    } catch (e) {

      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {

    try{

      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password
      });


      final user = UserMapper.userJsonToEntity(response.data);
      return user;

    } on DioException catch (e){

      if( e.response?.statusCode == 401){
        throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas');
      }

      if(e.type == DioExceptionType.connectionTimeout){
        throw CustomError("Revisar conexión a Internet");
      }

      throw Exception();

    } catch (e) {

      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
  
}