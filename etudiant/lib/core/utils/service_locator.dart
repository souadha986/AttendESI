import 'package:etudiant/core/navigation/router_generator.dart';
import 'package:etudiant/features/home/cubit/absence_cubit.dart';
import 'package:etudiant/features/home/cubit/alerts_cubit.dart';
import 'package:etudiant/features/justificatifs/cubit/update_cubit.dart';
import 'package:etudiant/features/notifications/cubit/notification_cubit.dart';
import 'package:etudiant/features/notifications/repo/notification_repo.dart';
import 'package:etudiant/features/planning/cubit/examen_cubit.dart';

import 'package:etudiant/features/planning/cubit/remplacement_cubit.dart';
import 'package:etudiant/features/planning/cubit/seance_normal_cubit.dart';

import 'package:etudiant/features/planning/repo/planning_api.dart';
import 'package:etudiant/features/qr_code/qr_cubit/qr_cubit.dart';
import 'package:etudiant/features/qr_code/repo/qr_repo.dart';
import 'package:etudiant/features/services/notification_repo_service.dart';
import 'package:etudiant/features/settings/repo/change_password_api.dart';
import 'package:etudiant/features/settings/repo/contact_admin_api.dart';
import 'package:etudiant/features/settings/repo/logout_api.dart';
import 'package:get_it/get_it.dart';
import 'package:etudiant/core/networking/dio_helper.dart';
import 'package:etudiant/core/utils/secure_storage.dart';
import 'package:etudiant/features/auth/login/cubit/auth_cubit.dart';
import 'package:etudiant/features/auth/login/repo/auth_api.dart';
import 'package:etudiant/features/auth/otp/cubit/otp_cubit.dart';
import 'package:etudiant/features/auth/otp/repo/otp_api.dart';
import 'package:etudiant/features/home/cubit/profile_cubit.dart';
import 'package:etudiant/features/home/repo/home_repo.dart';
import 'package:etudiant/features/justificatifs/cubit/justificatifs_cubit.dart';
import 'package:etudiant/features/justificatifs/cubit/soumettre_cubit.dart';
import 'package:etudiant/features/justificatifs/repo/justificatis_repo.dart';
import 'package:etudiant/features/settings/cubit/change_password_cubit.dart';
import 'package:etudiant/features/settings/cubit/contact_admin_cubit.dart';
import 'package:etudiant/features/settings/cubit/logout_cubit.dart';
import 'package:go_router/go_router.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerSingleton<GoRouter>(RouterGenerator.routes);
  sl.registerSingleton<SecureStorage>(SecureStorage());
  sl.registerSingleton<DioHelper>(DioHelper());

  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<DioHelper>()));
  sl.registerLazySingleton<OtpApi>(() => OtpApi(sl<DioHelper>()));
  sl.registerLazySingleton<HomeRepo>(() => HomeRepo(sl<DioHelper>()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));
  sl.registerLazySingleton<ChangePasswordApi>(
    () => ChangePasswordApi(sl<DioHelper>()),
  );
  sl.registerFactory<ContactAdminApi>(() => ContactAdminApi(sl<DioHelper>()));
  sl.registerFactory<LogoutApi>(() => LogoutApi(sl<DioHelper>()));
  sl.registerLazySingleton<NotificationRepo>(
    () => NotificationRepo(sl<DioHelper>()),
  );
  sl.registerLazySingleton<JustificatifsRepo>(
    () => JustificatifsRepo(sl<DioHelper>()),
  );
  sl.registerLazySingleton<PlanningRepo>(() => PlanningRepo(sl<DioHelper>()));

  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<OtpCubit>(() => OtpCubit(sl()));

  sl.registerFactory<JustificatifsCubit>(() => JustificatifsCubit(sl()));
  sl.registerFactory<SoumettreCubit>(() => SoumettreCubit(sl()));
  sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(sl()));
  sl.registerFactory<ContactAdminCubit>(() => ContactAdminCubit(sl()));
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl()));
  sl.registerFactory<UpdateCubit>(() => UpdateCubit(sl()));
  sl.registerFactory<NotificationsCubit>(() => NotificationsCubit(sl()));
  sl.registerFactory<AbsenceCubit>(() => AbsenceCubit(sl()));
  sl.registerFactory<ExamenCubit>(() => ExamenCubit(sl()));
  sl.registerFactory<RemplacementCubit>(() => RemplacementCubit(sl()));
  sl.registerFactory<SeanceNormaleCubit>(() => SeanceNormaleCubit(sl()));
  sl.registerLazySingleton(() => QrcodeRepo(sl()));
  sl.registerFactory(() => QrcodeCubit(sl<QrcodeRepo>()));
  sl.registerFactory(() => AlertCubit(sl<HomeRepo>()));
  sl.registerLazySingleton<NotificationServiceRepo>(
    () => NotificationServiceRepo(sl<DioHelper>()),
  );
}
