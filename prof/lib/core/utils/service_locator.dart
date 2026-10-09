import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:prof/core/navigation/router_generator.dart';
import 'package:prof/core/networking/dio_helper.dart';
import 'package:prof/core/utils/secire_storage.dart';
import 'package:prof/features/auth/login/cubit/auth_cubit.dart';
import 'package:prof/features/auth/login/repo/auth_api.dart';
import 'package:prof/features/auth/otp/cubit/otp_cubit.dart';
import 'package:prof/features/auth/otp/repo/otp_api.dart';
import 'package:prof/features/etudiant/cubit/envoyer_test_cubit.dart';
import 'package:prof/features/etudiant/cubit/etudiant_cubit.dart';
import 'package:prof/features/etudiant/cubit/groupe_cubit.dart';
import 'package:prof/features/etudiant/cubit/liste_etudiant_cubit.dart';
import 'package:prof/features/etudiant/cubit/marquer_absence_cubit.dart';
import 'package:prof/features/etudiant/cubit/module_cubit.dart';
import 'package:prof/features/etudiant/cubit/niveau_cubit.dart';
import 'package:prof/features/etudiant/cubit/remplacement_cubit.dart';
import 'package:prof/features/etudiant/cubit/specialite_cubit.dart';
import 'package:prof/features/etudiant/qr_code/cubit/qr_cubit.dart';
import 'package:prof/features/etudiant/qr_code/repo/qr_repo.dart';
import 'package:prof/features/etudiant/repo/marquer_absence_api.dart';
import 'package:prof/features/home/cubit/absence_cubit.dart';
import 'package:prof/features/home/cubit/profile_cubit.dart';
import 'package:prof/features/home/repo/home_repo.dart';
import 'package:prof/features/notifications/cubit/notification_cubit.dart';
import 'package:prof/features/notifications/repo/notification_repo.dart';
import 'package:prof/features/planning/cubit/examen_cubit.dart';
import 'package:prof/features/planning/cubit/remplacement_cubit.dart';

import 'package:prof/features/planning/cubit/seance_normale_cubit.dart';
import 'package:prof/features/planning/repo/planning_api.dart';

import 'package:prof/features/settings/cubit/change_password_cubit.dart';
import 'package:prof/features/settings/cubit/contact_admin_cubit.dart';
import 'package:prof/features/settings/cubit/logout_cubit.dart';
import 'package:prof/features/settings/repo/change_password_api.dart';
import 'package:prof/features/settings/repo/contact_admin_api.dart';
import 'package:prof/features/settings/repo/logout_api.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerSingleton<GoRouter>(RouterGenerator.routes);
  sl.registerSingleton<SecureStorage>(SecureStorage());
  sl.registerSingleton<DioHelper>(DioHelper());

  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<DioHelper>()));
  sl.registerLazySingleton<OtpApi>(() => OtpApi(sl<DioHelper>()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepo(sl<DioHelper>()));
  sl.registerLazySingleton<NotificationRepo>(
    () => NotificationRepo(sl<DioHelper>()),
  );
  sl.registerLazySingleton<MarquerAbsenceApi>(
    () => MarquerAbsenceApi(sl<DioHelper>()),
  );

  sl.registerLazySingleton<ChangePasswordApi>(
    () => ChangePasswordApi(sl<DioHelper>()),
  );
  sl.registerLazySingleton(() => GenerateQrRepo(sl<DioHelper>()));
  sl.registerFactory(() => GenerateQrCubit(sl<GenerateQrRepo>()));
  sl.registerFactory<ContactAdminApi>(() => ContactAdminApi(sl<DioHelper>()));
  sl.registerFactory<LogoutApi>(() => LogoutApi(sl<DioHelper>()));
  sl.registerFactory<PlanningRepo>(() => PlanningRepo(sl<DioHelper>()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<NiveauCubit>(() => NiveauCubit(sl()));
  sl.registerFactory<SpecialiteCubit>(() => SpecialiteCubit(sl()));
  sl.registerFactory<OtpCubit>(() => OtpCubit(sl()));
  sl.registerFactory<ModuleCubit>(() => ModuleCubit(sl()));
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit(sl()));
  sl.registerFactory<GroupeCubit>(() => GroupeCubit(sl()));
  sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(sl()));
  sl.registerFactory<ContactAdminCubit>(() => ContactAdminCubit(sl()));
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));
  sl.registerFactory<AbsenceCubit>(() => AbsenceCubit(sl()));
  sl.registerFactory<EtudiantCubit>(() => EtudiantCubit(sl()));
  sl.registerFactory<MarquerAbsenceCubit>(() => MarquerAbsenceCubit(sl()));
  sl.registerFactory<ListeEtudiantCubit>(() => ListeEtudiantCubit(sl()));
  sl.registerFactory<EnvoyerTestCubit>(() => EnvoyerTestCubit(sl()));
  sl.registerFactory<EligibleAbsentsCubit>(() => EligibleAbsentsCubit(sl()));
  sl.registerFactory<SeanceNormaleCubit>(() => SeanceNormaleCubit(sl()));
  sl.registerFactory<ExamenCubit>(() => ExamenCubit(sl()));
  sl.registerFactory<RemplacementCubit>(() => RemplacementCubit(sl()));
}
