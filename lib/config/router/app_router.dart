import 'package:go_router/go_router.dart';
import 'package:teslo/features/auth/presentation/screens/register_screen.dart';
import 'package:teslo/features/products/presentation/screens/products_screen.dart';

import '../../features/auth/presentation/screens/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [

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
  ///! TODO: Bloquear si no se está autenticado de alguna manera
);