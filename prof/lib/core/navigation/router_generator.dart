import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prof/core/navigation/app_routes.dart';
import 'package:prof/core/utils/service_locator.dart';
import 'package:prof/features/auth/login/cubit/auth_cubit.dart';
import 'package:prof/features/auth/login/login.dart';
import 'package:prof/features/auth/otp/cubit/otp_cubit.dart';
import 'package:prof/features/auth/otp/forget_password.dart';
import 'package:prof/features/auth/otp/otp_code.dart';
import 'package:prof/features/auth/otp/reset_password.dart';
import 'package:prof/features/etudiant/consulter_liste_etudiant/consulter_liste1.dart';
import 'package:prof/features/etudiant/consulter_liste_etudiant/consulter_liste2.dart';
import 'package:prof/features/etudiant/consulter_liste_etudiant/consulter_liste3.dart';
import 'package:prof/features/etudiant/consulter_liste_etudiant/liste_etudiant3.dart';
import 'package:prof/features/etudiant/cubit/envoyer_test_cubit.dart';
import 'package:prof/features/etudiant/cubit/etudiant_cubit.dart';
import 'package:prof/features/etudiant/cubit/groupe_cubit.dart';
import 'package:prof/features/etudiant/cubit/liste_etudiant_cubit.dart';
import 'package:prof/features/etudiant/cubit/marquer_absence_cubit.dart';
import 'package:prof/features/etudiant/cubit/module_cubit.dart';
import 'package:prof/features/etudiant/cubit/niveau_cubit.dart';
import 'package:prof/features/etudiant/cubit/remplacement_cubit.dart';
import 'package:prof/features/etudiant/cubit/specialite_cubit.dart';
import 'package:prof/features/etudiant/etudiant.dart';
import 'package:prof/features/etudiant/marquer_absence/liste_etudiant.dart';
import 'package:prof/features/etudiant/marquer_absence/marquer_absence1.dart';
import 'package:prof/features/etudiant/marquer_absence/marquer_absence2.dart';
import 'package:prof/features/etudiant/marquer_absence/marquer_absence3.dart';
import 'package:prof/features/etudiant/message_remplacement/message_remplacement1.dart';
import 'package:prof/features/etudiant/message_remplacement/message_remplacement2.dart';
import 'package:prof/features/etudiant/message_remplacement/message_remplacement3.dart';
import 'package:prof/features/etudiant/message_remplacement/message_remplacement4.dart';
import 'package:prof/features/etudiant/message_test/envoyer_message_test1.dart';
import 'package:prof/features/etudiant/message_test/envoyer_message_test2.dart';
import 'package:prof/features/etudiant/message_test/envoyer_message_test3.dart';
import 'package:prof/features/etudiant/message_test/envoyer_message_test4.dart';
import 'package:prof/features/etudiant/modifier_absence/liste_modifier.dart';
import 'package:prof/features/etudiant/modifier_absence/modifier_absence1.dart';
import 'package:prof/features/etudiant/modifier_absence/modifier_absence2.dart';
import 'package:prof/features/etudiant/modifier_absence/modifier_absence3.dart';
import 'package:prof/features/etudiant/qr_code/cubit/qr_cubit.dart';
import 'package:prof/features/etudiant/qr_code/qr_code.dart';

import 'package:prof/features/home/profile_screen.dart';
import 'package:prof/features/main_screen/main_screen.dart';
import 'package:prof/features/notifications/cubit/notification_cubit.dart';
import 'package:prof/features/notifications/notification_details.dart';
import 'package:prof/features/notifications/notifications.dart';

import 'package:prof/features/settings/change_password.dart';
import 'package:prof/features/settings/contact_admin.dart';
import 'package:prof/features/settings/cubit/change_password_cubit.dart';
import 'package:prof/features/settings/cubit/contact_admin_cubit.dart';
import 'package:prof/features/splashscreen/splashscreen.dart';

class RouterGenerator {
  static GoRouter routes = GoRouter(
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
        name: AppRoutes.generateqr,
        path: '/generate-qr',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<GenerateQrCubit>(),
            child: GenerateQrScreen(
              matiereId: extra['matiereId'] as int,
              moduleName: extra['moduleName'] as String,
              groupe: extra['groupe'] as String, // ✅ keep as String
              niveau: extra['niveau'] as String,
              specialite: extra['specialite'] as String,
              heureDebut: extra['heureDebut'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.splashscreen,
        name: AppRoutes.splashscreen,
        builder: (context, state) => SplashScreen(),
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
        path: AppRoutes.consulterliste1,
        name: AppRoutes.consulterliste1,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<NiveauCubit>()),
            BlocProvider(create: (context) => sl<SpecialiteCubit>()),
          ],
          child: ConsulterListe1(),
        ),
      ),
      GoRoute(
        path: AppRoutes.marquerabsence1,
        name: AppRoutes.marquerabsence1,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<NiveauCubit>()),
            BlocProvider(create: (context) => sl<SpecialiteCubit>()),
          ],
          child: MarquerAbsence1(),
        ),
      ),
      GoRoute(
        path: AppRoutes.envoyertest1,
        name: AppRoutes.envoyertest1,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<NiveauCubit>()),
            BlocProvider(create: (context) => sl<SpecialiteCubit>()),
          ],
          child: EnvoyerMessageTest1(),
        ),
      ),
      GoRoute(
        path: AppRoutes.remplacement1,
        name: AppRoutes.remplacement1,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<NiveauCubit>()),
            BlocProvider(create: (context) => sl<SpecialiteCubit>()),
          ],
          child: MessageRemplacement1(),
        ),
      ),
      GoRoute(
        path: AppRoutes.modifierabsence1,
        name: AppRoutes.modifierabsence1,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<NiveauCubit>()),
            BlocProvider(create: (context) => sl<SpecialiteCubit>()),
          ],
          child: ModifierAbsence1(),
        ),
      ),
      GoRoute(
        name: AppRoutes.modifierabsence2,
        path: AppRoutes.modifierabsence2,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<GroupeCubit>(),

            child: ModifierAbsence2(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.marquerabsence2,
        path: AppRoutes.marquerabsence2,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<GroupeCubit>(),

            child: MarquerAbsence2(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
            ),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.envoyertest2,
        path: AppRoutes.envoyertest2,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<GroupeCubit>(),
            child: EnvoyerMessageTest2(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.remplacement2,
        path: AppRoutes.remplacement2,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<GroupeCubit>(),
            child: MessageRemplacement2(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
            ),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.consulterliste2,
        path: AppRoutes.consulterliste2,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<GroupeCubit>(),

            child: ConsulterListe2(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.marquerabsence3,
        path: AppRoutes.marquerabsence3,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<ModuleCubit>(),
            child: MarquerAbsence3(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
              groupe: extra['groupe'],
            ),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.envoyertest3,
        path: AppRoutes.envoyertest3,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<ModuleCubit>(),
            child: EnvoyerMessageTest3(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
              groupe: extra['groupe'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.remplecement3,
        path: AppRoutes.remplecement3,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<ModuleCubit>(),
            child: MessageRemplacement3(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
              groupe: extra['groupe'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.envoyertest4,
        path: AppRoutes.envoyertest4,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<EnvoyerTestCubit>(),
            child: EnvoyerMessageTest4(
              groupe: extra['groupe'],
              specialite: extra['specialite'],
              niveau: extra['niveau'],
              matiereId: extra['matiereId'],
              salle: extra['salle'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.remplecement4,
        path: AppRoutes.remplecement4,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<EligibleAbsentsCubit>()),
              BlocProvider(create: (context) => sl<EnvoyerTestCubit>()),
            ],
            child: MessageRemplacement4(
              dateAbsence: extra['dateAbsence'],
              groupe: extra['groupe'],
              specialite: extra['specialite'],
              niveau: extra['niveau'],
              matiereId: extra['matiereId'],
              salle: extra['salle'],
              dateRemplacement: extra['dateRemplacement'],
              heurefin: extra['heurefin'],
              heuredebut: extra['heuredebut'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.consulterliste3,
        path: AppRoutes.consulterliste3,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<ModuleCubit>(),
            child: ConsulterListe3(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
              groupe: extra['groupe'],
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.modifierabsence3,
        path: AppRoutes.modifierabsence3,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => sl<ModuleCubit>(),
            child: ModifierAbsence3(
              niveau: extra['niveau'],
              specialite: extra['specialite'],
              groupe: extra['groupe'],
            ),
          );
        },
      ),

      GoRoute(
        name: AppRoutes.listeetudiant,
        path: AppRoutes.listeetudiant,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<EtudiantCubit>()),
              BlocProvider(create: (context) => sl<MarquerAbsenceCubit>()),
            ],
            child: ListeEtudiant(
              time: data['time'] as String,
              niveau: data['niveau'] as String,
              specialite: data['specialite'] as String,
              groupe: data['groupe'] as String,
              moduleId: data['moduleId'] as int,
              moduleName: data['moduleName'] as String,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.listeetudiantmodifier,
        path: AppRoutes.listeetudiantmodifier,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<EtudiantCubit>()),
              BlocProvider(create: (context) => sl<MarquerAbsenceCubit>()),
            ],
            child: ListeModifier(
              heure: data['heure'] as String,
              niveau: data['niveau'] as String,
              specialite: data['specialite'] as String,
              groupe: data['groupe'] as String,
              moduleId: data['moduleId'] as String,
              moduleName: data['moduleName'] as String,
              date: data['date'] as String,
            ),
          );
        },
      ),
      GoRoute(
        name: AppRoutes.listeetudiant3,
        path: AppRoutes.listeetudiant3,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => sl<ListeEtudiantCubit>()),
            ],
            child: ListeEtudiant3(
              niveau: data['niveau'] as String,
              specialite: data['specialite'] as String,
              groupe: data['groupe'] as String,
              matiereId: data['moduleId'] as String,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.etudiant,
        name: AppRoutes.etudiant,
        builder: (context, state) => Etudiant(),
      ),
      GoRoute(
        path: AppRoutes.notificationdetails,
        name: AppRoutes.notificationdetails,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;

          return NotificationDetails(
            title: args['title'] ?? "Sans titre",
            sender: args['sender'] ?? "Inconnu",

            date: args['date'] ?? "",
            message: args['message'] ?? "",
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
        path: AppRoutes.profileScreen,
        name: AppRoutes.profileScreen,
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          return ProfileScreen(
            nom: args['nom'],
            prenom: args['prenom'],

            willayaNaiss: args['willayaNaiss'],
            dateNaissance: args['dateNaissance'],
            description: args['description'],
          );
        },
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
