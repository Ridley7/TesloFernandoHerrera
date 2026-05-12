

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo/features/shared/infrastructure/inputs/email_input.dart';
import 'package:teslo/features/shared/infrastructure/inputs/password_input.dart';
import 'package:teslo/presentation/providers/authentication_provider.dart';

final loginFormProvider = NotifierProvider<LoginFormNotifier, LoginFormState>(
  LoginFormNotifier.new,
);


class LoginFormNotifier extends Notifier<LoginFormState> {

  late final Function(String, String) loginUserCallback;

  @override
  LoginFormState build() {

    loginUserCallback = ref.read(authenticationProvider.notifier).login;
    return LoginFormState();
  }

  void onEmailChange(String value){

    final EmailInput newEmail = EmailInput.dirty(value);

    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.password])
    );

  }

  void onPasswordChange(String value){

    final PasswordInput newPassword = PasswordInput.dirty(value);

    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ newPassword, state.email])
    );

  }

  void onFormSubmit() async{

    //Indicamos que se ha posteado el formulario
    _touchEveryField();

    if( !state.isValid ) return;

    //Hacemos login contra el backend
    await loginUserCallback(state.email.value, state.password.value);

  }

  void _touchEveryField(){
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);

    state = state.copyWith(
      email: email,
      password: password,
      isFormPosted: true,
      isValid: Formz.validate([ state.email, state.password ])
    );
  }


}

//1. state del provider
class LoginFormState{
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final EmailInput email;
  final PasswordInput password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure()
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    EmailInput? email,
    PasswordInput? password,
  }) => LoginFormState(
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
      email: email ?? this.email,
      password: password ?? this.password
  );

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
''';
  }
}

/*
Temario: word, excel, power point y access
Horario: lunes a jueves - 18:30 - 21:00. Martes 19
Duracion hasta el 25 de junio.
Compatibilidad laboral: ninguno.
Salario:
Cuanto tardais en pagar:
 */