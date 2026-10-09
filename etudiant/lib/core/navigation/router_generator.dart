import 'package:etudiant/core/navigation/navigation_key.dart';
import 'package:etudiant/features/home/profile_screen.dart';
import 'package:etudiant/features/justificatifs/cubit/soumettre_cubit.dart';
import 'package:etudiant/features/justificatifs/cubit/update_cubit.dart';
import 'package:etudiant/features/justificatifs/edit_justification.dart';
import 'package:etudiant/features/justificatifs/soumettre_justificatifs.dart';
import 'package:etudiant/features/main_screen/main_screen.dart';
import 'package:etudiant/features/notifications/cubit/notification_cubit.dart';
import 'package:etudiant/features/notifications/notification_details.dart';
import 'package:etudiant/features/notifications/notifications.dart';
import 'package:etudiant/features/settings/change_password.dart';
import 'package:etudiant/features/settings/contact_admin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/utils/service_locator.dart';
import 'package:etudiant/features/auth/login/cubit/auth_cubit.dart';
import 'package:etudiant/features/auth/otp/cubit/otp_cubit.dart';
import 'package:etudiant/features/auth/otp/forget_password.dart';
import 'package:etudiant/features/auth/login/login.dart';
import 'package:etudiant/features/auth/otp/otp_code.dart';
import 'package:etudiant/features/auth/otp/reset_password.dart';
import 'package:etudiant/features/settings/cubit/change_password_cubit.dart';
import 'package:etudiant/features/settings/cubit/contact_admin_cubit.dart';

import 'package:etudiant/features/splashscreen/splashscreen.dart';

class RouterGenerator {
  static GoRouter routes = GoRouter(
    navigatorKey: navigatorKey,
    routes: [
      //if u want to add a transition affect to alll the pages u need to add this code in the main.dart
      //theme: ThemeData(
      // pageTransitionsTheme: const PageTransitionsTheme(
      //  builders: {
      //   TargetPlatform.android: GoTransitions.fadeUpwards,
      //  TargetPlatform.iOS: GoTransitions.cupertino,
      //  TargetPlatform.macOS: GoTransitions.cupertino,
      // },
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
        path: AppRoutes.soumettrejustificatif,
        name: AppRoutes.soumettrejustificatif,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<SoumettreCubit>(),
            child: const SoumettreJustificatifsScreen(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.forgetpassword,
        name: AppRoutes.forgetpassword,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => sl<OtpCubit>(),
            child: const ForgetPassword(),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.splashscreen,
        name: AppRoutes.splashscreen,
        builder: (context, state) => SplashScreen(),
      ),

      GoRoute(
        path: AppRoutes.notificationdetails,
        name: AppRoutes.notificationdetails,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;

          return NotificationDetails(
            title: args['title'] ?? "Sans titre",
            from: args['from'] ?? "Inconnu",
            to: args['to'] ?? "N/A",
            date: args['date'] ?? "",
            message: args['message'] ?? "",
          );
        },
      ),
      GoRoute(
        path: AppRoutes.otpcode,
        name: AppRoutes.otpcode,
        builder: (context, state) {
          final email = state.extra as String? ?? '';

          return BlocProvider(
            create: (context) => sl<OtpCubit>(),
            child: OtpCode(email: email),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.resetpassword,
        name: AppRoutes.resetpassword,
        builder: (context, state) {
          final email = state.uri.queryParameters['email'] ?? '';
          final otp = state.uri.queryParameters['otp'] ?? '';
          return BlocProvider(
            create: (context) => sl<OtpCubit>(),
            child: ResetPassword(email: email, otp: otp),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.mainScreen,
        name: AppRoutes.mainScreen,
        builder: (context, state) => MainScreen(),
      ),

      GoRoute(
        path: AppRoutes.profileScreen,
        name: AppRoutes.profileScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ProfileScreen(
            nom: args['nom'],
            prenom: args['prenom'],

            willayaNaiss: args['willayaNaiss'],
            dateNaissance: args['dateNaissance'],
            situation: args['situation'],
            groupe: args['groupe'],
            specialite: args['specialite'],
          );
        },
      ),
      GoRoute(
        path: AppRoutes.notification,
        name: AppRoutes.notification,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<NotificationsCubit>(),
          child: const Notifications(),
        ),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: AppRoutes.changePassword,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ChangePasswordCubit>(),
          child: const ChangePassword(),
        ),
      ),
      GoRoute(
        name: AppRoutes.editjustification,
        path: AppRoutes.editjustification,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<UpdateCubit>(),
            child: ModifierJustificatifScreen(
              id: args['id']!.toString(),
              matiereIds: (args['matiereIds'] as List<int>?) ?? [],
              datedebutAbsence: args['datedebutAbsence']!.toString(),
              datefinAbsence: args['datefinAbsence']!.toString(),
              typeJustification: args['typeJustification']!.toString(),
              raisonAbsence: args['raisonAbsence']!.toString(),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.contactAdmin,
        name: AppRoutes.contactAdmin,
        builder: (context, state) => BlocProvider(
          create: (context) => sl<ContactAdminCubit>(),
          child: const ContactAdmin(),
        ),
      ),
    ],

    initialLocation: AppRoutes.splashscreen,
  );
}
