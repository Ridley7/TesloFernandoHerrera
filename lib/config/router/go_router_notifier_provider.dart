import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo/presentation/providers/authentication_provider.dart';

final goRouterNotifierProvider = Provider((ref){

  final notifier = GoRouterNotifier();

  ref.listen(authenticationProvider, (previous, next){
    notifier.authenticationStatus = next.authenticationStatus;
  });

  return notifier;

});

class GoRouterNotifier extends ChangeNotifier{

  AuthenticationStatus _authenticationStatus = AuthenticationStatus.checking;

  AuthenticationStatus get authenticationStatus => _authenticationStatus;

  set authenticationStatus( AuthenticationStatus _newStatus){
    _authenticationStatus = _newStatus;
    notifyListeners();
  }

}