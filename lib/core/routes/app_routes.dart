import 'package:nana/core/routes/route.dart';
import 'package:nana/features/aboutus/screens/about_us.dart';
import 'package:nana/features/address/screens/address_screen.dart';
import 'package:nana/features/auth/screens/forget_screen.dart';

import 'package:nana/features/auth/screens/login_screen.dart';
import 'package:nana/features/auth/screens/signup_screen.dart';
import 'package:nana/features/cart/screens/cart_screen.dart';
import 'package:nana/features/navbar/bottom_navbar/bottom_navbar_screen.dart';
import 'package:nana/features/onboarding/screens/onboarding.dart';
import 'package:nana/features/product/models/product/datum.dart';

import 'package:nana/features/product/screens/product_detail_screen.dart';
import 'package:nana/features/product/screens/product_screen.dart';
import 'package:nana/features/setting/screens/setting_screen.dart';
import 'package:nana/features/startup/startup_screen.dart';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.startup,

    routes: <RouteBase>[
      // Startup
      GoRoute(
        path: Routes.startup,
        builder: (BuildContext context, GoRouterState state) {
          return const StartupScreen();
        },
      ),

      // Onboarding
      GoRoute(
        path: Routes.onboarding,
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),

      // Signup
      GoRoute(
        path: Routes.signup,
        builder: (BuildContext context, GoRouterState state) {
          return const SignupScreen();
        },
      ),

      // Login
      GoRoute(
        path: Routes.login,
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
        },
      ),

      // Home
      GoRoute(
        path: Routes.home,
        builder: (context, state) {
          return const BottomNavbar();
        },
      ),

      // builder: (context, state) {
      //     return BlocProvider(
      //       create: (context) =>
      //           ProductBloc(ProudctRepository(ApiService()))
      //             ..add(GetProducts()),
      //       child: const ProductScreen(),
      //     );
      //   },

      // Product
      GoRoute(
        path: Routes.product,
        builder: (BuildContext context, GoRouterState state) {
          return ProductScreen();
        },

        // builder: (context, state) {
        //     return BlocProvider(
        //       create: (context) => ProductBloc(
        //         // repository/usecase here
        //       )..add(FetchProducts()),
        //       child: const ProductScreen(),
        //     );
        //   },
      ),

      // Cart
      GoRoute(
        path: Routes.cart,
        builder: (BuildContext context, GoRouterState state) {
          // final product = state.extra as ProductModel;
          return CartScreen();
        },
      ),
      // Address
      GoRoute(
        path: Routes.address,
        builder: (BuildContext context, GoRouterState state) {
          return AddressScreen();
        },
      ),
      GoRoute(
        path: Routes.setting,
        builder: (BuildContext context, GoRouterState state) {
          return SettingsScreen();
        },
      ),
      GoRoute(
        path: Routes.forget,
        builder: (BuildContext context, GoRouterState state) {
          return ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: Routes.aboutus,
        builder: (BuildContext context, GoRouterState state) {
          return AboutUsScreen();
        },
      ),
      // Onboarding
      GoRoute(
        path: Routes.productDetail,
        builder: (BuildContext context, GoRouterState state) {
          final product = state.extra as Datum?;
          if (product == null) {
            return const Scaffold(
              body: Center(child: Text('Product not found')),
            );
          }

          return ProductDetailScreen(product: product);
        },
      ),
    ],
  );
}
