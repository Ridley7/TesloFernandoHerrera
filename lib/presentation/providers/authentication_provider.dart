import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/domain/entities/user.dart';
import 'package:teslo/features/auth/domain/repositories/authentication_repository.dart';
import 'package:teslo/features/auth/infrastructure/errors/custom_error.dart';
import 'package:teslo/features/auth/infrastructure/repositories/authentication_repository_implementation.dart';
import 'package:teslo/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo/features/shared/infrastructure/services/key_value_storage_service_implementation.dart';

//3. El provider que gestiona el notifier
final authenticationProvider = NotifierProvider<AuthenticationNotifier, AuthenticationState>(
    AuthenticationNotifier.new,
);

//2. El notifier que gestiona el state
class AuthenticationNotifier extends Notifier<AuthenticationState>{

  late final AuthenticationRepository authenticationRepository;
  late final KeyValueStorageService keyValueStorageService;

  @override
  AuthenticationState build() {
    authenticationRepository = AuthenticationRepositoryImplementation();
    keyValueStorageService = KeyValueStorageServiceImplementation();
    checkAuthenticationStatus();
    return const AuthenticationState();
  }

  Future<void> login (String email, String password) async{
    await Future.delayed(Duration(milliseconds: 500));

    try{
      final user = await authenticationRepository.login(email, password);
      //Ponemos al usuario en el state
      _setLoggerUser(user);

    } on CustomError catch (e){
      logout(e.message);
    } catch (e){
      logout("Error no controlado");
    }
  }

  void checkAuthenticationStatus() async {

    final String? token = await keyValueStorageService.getValue<String>('token');

    //Devolvemos logout por que este metodo se ejecuta inmediamente que se llama
    //este provider, en ese momento el AuthentiactionStatus es checking. Si
    //el token no es valido llamamos a logout para que el AuthenticationStatus sea
    //notAuthenticated
    if(token == null) return logout();

    //Si no es null, debemos comprobar el token contra el backend
    try{
      final User user = await authenticationRepository.checkAuthStatus(token);
      _setLoggerUser(user);
    } catch (e){
      logout();
    }
  }

  void _setLoggerUser(User user) async {

    await keyValueStorageService.setKeyValue('token', user.token);

    state = state.copyWith(
        authenticationStatus: AuthenticationStatus.authenticated,
        user: user
    );


  }

  Future<void> logout([String? message]) async{

    await keyValueStorageService.removeKey('token');

    state = state.copyWith(
      authenticationStatus: AuthenticationStatus.notAuthenticated,
      user: null,
      errorMessage: message
    );
  }

}

//1. state


enum AuthenticationStatus { checking, authenticated, notAuthenticated }

class AuthenticationState{
  final AuthenticationStatus authenticationStatus;
  final User? user;
  final String errorMessage;

  const AuthenticationState({
    this.authenticationStatus = AuthenticationStatus.checking,
    this.user,
    this.errorMessage = ''
  });

  AuthenticationState copyWith({
    AuthenticationStatus? authenticationStatus,
    User? user,
    String? errorMessage
}) => AuthenticationState(
    authenticationStatus: authenticationStatus ?? this.authenticationStatus,
    user: user ?? this.user,
    errorMessage: errorMessage ?? this.errorMessage
  );

}