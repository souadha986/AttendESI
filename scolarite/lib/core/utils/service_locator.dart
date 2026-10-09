import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:scolarite/core/navigation/router_generator.dart';
import 'package:scolarite/core/networking/dio_helper.dart';
import 'package:scolarite/core/utils/secure_storage.dart';
import 'package:scolarite/features/absences/cubit/absences_cubit.dart';
import 'package:scolarite/features/absences/cubit/absences_validate_cubit.dart';
import 'package:scolarite/features/absences/cubit/filtre_cubit.dart';
import 'package:scolarite/features/absences/repo/absences_repo.dart';
import 'package:scolarite/features/contact_admin/repo/contact_admin_repo.dart';
import 'package:scolarite/features/dashboard/cubit/bar_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/cards_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/pie_cubit.dart';
import 'package:scolarite/features/dashboard/repo/dashboard_repo.dart';
import 'package:scolarite/features/historique_notification/cubit/notif_cubit.dart';
import 'package:scolarite/features/historique_notification/repo/notif_repo.dart';
import 'package:scolarite/features/justificatifs/cubit/deaitls_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/justificatif_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/refus_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/valider_cubit.dart';
import 'package:scolarite/features/justificatifs/repo/justificatifs_repo.dart';
import 'package:scolarite/features/login/cubit/auth_cubit.dart';
import 'package:scolarite/features/login/repo/auth_api.dart';
import 'package:scolarite/features/main_screen/cubit/logout_cubit.dart';
import 'package:scolarite/features/main_screen/repo/logout_api.dart';
import 'package:scolarite/features/modifier_absences/cubit/absence_modif_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/modif_liste_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/modifier_cubit.dart';
import 'package:scolarite/features/modifier_absences/repo/absence_modif_repo.dart';
import 'package:scolarite/features/planning/cubit/exam_cubit.dart';
import 'package:scolarite/features/planning/cubit/planning_cubit.dart';
import 'package:scolarite/features/planning/repo/planning_repo.dart';
import 'package:scolarite/features/profile/cubit/profile_cubit.dart';
import 'package:scolarite/features/profile/repo/profile_api.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<GoRouter>(RouterGenerator.routes);
  sl.registerSingleton<SecureStorage>(SecureStorage());
  sl.registerSingleton<DioHelper>(DioHelper());

  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<DioHelper>()));
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));

  sl.registerLazySingleton<LogoutApi>(() => LogoutApi(sl<DioHelper>()));
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl()));

  sl.registerLazySingleton<ProfileApi>(() => ProfileApi(sl<DioHelper>()));
  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl()));

  sl.registerLazySingleton<ContactAdminRepo>(
    () => ContactAdminRepo(sl<DioHelper>()),
  );

  sl.registerLazySingleton<DashboardRepo>(() => DashboardRepo(sl<DioHelper>()));
  sl.registerFactory<CardsCubit>(() => CardsCubit(sl()));
  sl.registerFactory<BarCubit>(() => BarCubit(sl()));
  sl.registerFactory<PieCubit>(() => PieCubit(sl()));

  sl.registerLazySingleton<JustificatifsApi>(
    () => JustificatifsApi(sl<DioHelper>()),
  );
  sl.registerFactory<JustificatifsCubit>(() => JustificatifsCubit(sl()));
  sl.registerFactory<JustificatifDetailsCubit>(
    () => JustificatifDetailsCubit(sl()),
  );
  sl.registerFactory<ValiderCubit>(() => ValiderCubit(sl()));
  sl.registerFactory<RefusCubit>(() => RefusCubit(sl()));

  sl.registerLazySingleton<PlanningApi>(() => PlanningApi(sl<DioHelper>()));
  sl.registerFactory<PlanningCubit>(() => PlanningCubit(sl()));
  sl.registerFactory<ExamCubit>(() => ExamCubit(sl()));

  
  sl.registerLazySingleton<AbsenceApi>(() => AbsenceApi(sl<DioHelper>()));
  sl.registerFactory<FiltreCubit>(() => FiltreCubit(sl()));
  sl.registerFactory<AbsenceCubit>(() => AbsenceCubit(sl()));
  sl.registerFactory<AbsencesValidateCubit>(() => AbsencesValidateCubit(sl()));
  
  sl.registerLazySingleton<AbsenceModifApi>(() => AbsenceModifApi(sl<DioHelper>()));
  sl.registerFactory<AbsenceModifCubit>(() => AbsenceModifCubit(sl()));
   sl.registerFactory<ModifListeCubit>(() => ModifListeCubit(sl()));
    sl.registerFactory<ModifierCubit>(() => ModifierCubit(sl()));

 sl.registerLazySingleton<NotifApi>(() => NotifApi(sl<DioHelper>()));
  sl.registerFactory<NotifCubit>(() => NotifCubit(sl()));

}
