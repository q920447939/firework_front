import 'package:go_router/go_router.dart';
import '../modules/home/home_view.dart';
import '../modules/detail/detail_view.dart';

import '../modules/cart/cart_view.dart';
import '../modules/user/user_view.dart';




class AppRoutes {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeView(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) => DetailView(productId: state.pathParameters['id']!),
      ),


      GoRoute(
        path: '/user',
        builder: (context, state) => const UserView(),
      ),


    ],
  );
}
