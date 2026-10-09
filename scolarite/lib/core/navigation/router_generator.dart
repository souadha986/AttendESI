import 'package:scolarite/core/navigation/app_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:scolarite/core/utils/service_locator.dart';
import 'package:scolarite/features/dashboard/cubit/bar_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/cards_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/pie_cubit.dart';
import 'package:scolarite/features/main_screen/cubit/logout_cubit.dart';
import 'package:scolarite/features/main_screen/main_screen.dart';
import 'package:scolarite/features/login/cubit/auth_cubit.dart';
import 'package:scolarite/features/login/login.dart';
import 'package:scolarite/features/profile/cubit/profile_cubit.dart';
import 'package:scolarite/features/splashscreen/splashscreen.dart';

class RouterGenerator {
  static GoRouter routes = GoRouter(
    routes: [
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
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<LogoutCubit>()),
              //dashboard
              BlocProvider(create: (_) => sl<ProfileCubit>()..refreshProfile()),
              BlocProvider(create: (_) => sl<CardsCubit>()..getDashboard()),
              BlocProvider(create: (_) => sl<BarCubit>()),
              BlocProvider(create: (_) => sl<PieCubit>()),
              
            ],
            child: MainScreen(
              initialIndex:
                  int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0,
            ),
          );
        },
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
