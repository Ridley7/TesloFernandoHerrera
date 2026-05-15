import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo/config/router/go_router_notifier_provider.dart';
import 'package:teslo/features/auth/presentation/screens/check_auth_status_screen.dart';
import 'package:teslo/features/auth/presentation/screens/login_screen.dart';
import 'package:teslo/features/auth/presentation/screens/register_screen.dart';
import 'package:teslo/features/products/presentation/screens/products_screen.dart';
import 'package:teslo/presentation/providers/authentication_provider.dart';

/*
Dado que queremos que el appRouter se encargue de los redireccionamientos
y protección de rutas envolvemos el appRouter en un provider para darle
acceso al appRouter, mediantel ref, al estado de la autorización del
usuario y en base a este dato appRouter gestione un redireccionamiento
u otro
 */
final appRouterProvider = Provider((ref){

  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    /*
    refreshListenable nos deja conectar algo que cuando cambie se va
    a ejecutar el redireccionamiento. En este caso ese 'algo' es la
    autorización del usuario en el authentication_provider
     */
    refreshListenable: goRouterNotifier,
    routes: [

      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
    ],

    redirect: (context, state){

      //Cuando el usuario hace login correctamente el estado de la autentiación
      //cambia de autenticado a no autenticado, pero ese redirect no se entera
      //de ese cambio. Para entrar aqui hay que hacer un context.go,
      //context.push o sucedaneo. Una solución no es llamar forzadamente
      //a alguna ruta para que el redirect se ejecute.
      //La propiedad RefreshListeneable hace posible que se ejecute este redirect
      //en base a reglas que nosotros indiquemos.
      final isGoingTo = state.matchedLocation;
      final authStatus = goRouterNotifier.authenticationStatus;

      if( isGoingTo == "/splash" && authStatus == AuthenticationStatus.checking) return null;

      if(authStatus == AuthenticationStatus.notAuthenticated){
        if(isGoingTo == "/login" || isGoingTo == "/register" ) return null;

        return "/login";
      }

      if(authStatus == AuthenticationStatus.authenticated){
        if(isGoingTo == "/login" || isGoingTo == "/register" || isGoingTo == "/splash"){
          return "/";
        }
      }

      return null;
    }

  );

});
