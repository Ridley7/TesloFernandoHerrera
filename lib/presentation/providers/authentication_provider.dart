import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/features/auth/domain/entities/user.dart';
import 'package:teslo/features/auth/domain/repositories/authentication_repository.dart';
import 'package:teslo/features/auth/infrastructure/errors/custom_error.dart';
import 'package:teslo/features/auth/infrastructure/repositories/authentication_repository_implementation.dart';

//3. El provider que gestiona el notifier
final authenticationProvider = NotifierProvider<AuthenticationNotifier, AuthenticationState>(
    AuthenticationNotifier.new,
);

//2. El notifier que gestiona el state
class AuthenticationNotifier extends Notifier<AuthenticationState>{

  late final AuthenticationRepository authenticationRepository;

  @override
  AuthenticationState build() {
    authenticationRepository = AuthenticationRepositoryImplementation();
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

    print("State");
    //print(state.user!.token);

  }

  void _setLoggerUser(User user){
    state = state.copyWith(
        authenticationStatus: AuthenticationStatus.authenticated,
        user: user
    );
  }

  Future<void> logout([String? message]) async{
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