import 'package:admin/core/navigation/app_routes.dart';
import 'package:admin/core/utils/service_locator.dart';
import 'package:admin/features/auth/login/cubit/auth_cubit.dart';
import 'package:admin/features/auth/login/login.dart';
import 'package:admin/features/main_screen/main_screen.dart';
import 'package:admin/features/splashscreen/splashscreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RouterGenerator {
  static GoRouter routes = GoRouter(
    routes: [
      //if u want to add a transition affect to alll the pages u need to add this code in the main.dart
      //theme: ThemeData(
      // pageTransitionsTheme: const PageTransitionsTheme(
      //  builders: {
      //   TargetPlatform.android: GoTransitions.fadeUpwards,
      //  TargetPlatform.iOS: GoTransitions.cupertino,
      // TargetPlatform.macOS: GoTransitions.cupertino,
      //},
      // ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.login,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<AuthCubit>(),
            child: const Login(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.mainscreen,
        name: AppRoutes.mainscreen,
        builder: (context, state) => MainScreen(),
      ),
      GoRoute(
        path: AppRoutes.splashscreen,
        name: AppRoutes.splashscreen,
        builder: (context, state) => SplashScreen(),
      ),
    ],
    initialLocation: AppRoutes.splashscreen,
  );
}
