import 'package:admin/core/navigation/router_generator.dart';
import 'package:admin/core/networking/dio_helper.dart';
import 'package:admin/core/utils/secire_storage.dart';
import 'package:admin/features/auth/login/cubit/auth_cubit.dart';
import 'package:admin/features/auth/login/repo/auth_api.dart';
import 'package:admin/features/emploi/cubit/emploi_cubit.dart';
import 'package:admin/features/emploi/cubit/import_emploi_cubit.dart';
import 'package:admin/features/emploi/cubit/import_examen_cubit.dart';
import 'package:admin/features/emploi/repo/emploi_api.dart';
import 'package:admin/features/emploi/repo/import_emploi_api.dart';
import 'package:admin/features/emploi/repo/import_examen_api.dart';
import 'package:admin/features/exclusion/cubit/action_exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/seuil_cubit.dart';
import 'package:admin/features/exclusion/repo/exclusion_repo.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/add_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/delete_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/desarchive_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/import_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/liste_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/update_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/etudiant_repo.dart';
import 'package:admin/features/gestion_comptes/etudiant/repo/import_etudiant_api.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/add_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/delete_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/desarchive_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/import_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/liste_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/update_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/repo/import_prof_api.dart';
import 'package:admin/features/gestion_comptes/prof/repo/prof_repo.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/add_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/delete_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/scolarite_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/update_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/repo/scolarite_repo.dart';
import 'package:admin/features/historique_notification/cubit/mark_read_cubit.dart';
import 'package:admin/features/historique_notification/cubit/notification_cubit.dart';
import 'package:admin/features/historique_notification/cubit/reply_cubit.dart';
import 'package:admin/features/historique_notification/repo/notification_historique_repo.dart';
import 'package:admin/features/parametre/cubit/change_mdp_cubit.dart';
import 'package:admin/features/parametre/cubit/import_matieres_cubit.dart';
import 'package:admin/features/parametre/cubit/import_salles_cubit.dart';
import 'package:admin/features/parametre/cubit/logout_cubit.dart';
import 'package:admin/features/parametre/repo/change_mdp_api.dart';
import 'package:admin/features/parametre/repo/import_matieres_api.dart';
import 'package:admin/features/parametre/repo/import_salles_api.dart';
import 'package:admin/features/parametre/repo/logout_api.dart';
import 'package:admin/features/tableau_board/cubit/cards_cubit.dart';
import 'package:admin/features/tableau_board/cubit/chart_cubit.dart';
import 'package:admin/features/tableau_board/cubit/niveau_cubit.dart';
import 'package:admin/features/tableau_board/cubit/profile_cubit.dart';
import 'package:admin/features/tableau_board/cubit/specialite_cubit.dart';
import 'package:admin/features/tableau_board/repo/profile_api.dart';
import 'package:admin/features/tableau_board/repo/tableau_bord_api.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

GetIt sl = GetIt.instance;

void setupServiceLocator() {
  sl.registerSingleton<GoRouter>(RouterGenerator.routes);
  sl.registerSingleton<SecureStorage>(SecureStorage());
  sl.registerSingleton<DioHelper>(DioHelper());

  // ✅ Fix : injecter le Bearer token sur chaque requête
  sl<DioHelper>().dio!.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final bool needsToken = options.extra['needsToken'] ?? true;
        if (needsToken) {
          final String? token = await sl<SecureStorage>().getaccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
    ),
  );
  sl.registerLazySingleton<AuthApi>(() => AuthApi(sl<DioHelper>()));
  sl.registerLazySingleton<EtudiantRepo>(() => EtudiantRepo(sl<DioHelper>()));

  /*
  sl.registerLazySingleton<HomeRepo>(() => HomeRepo(sl<DioHelper>()));
  sl.registerLazySingleton<CartRepo>(() => CartRepo(sl<DioHelper>()));
  */
  sl.registerFactory<AuthCubit>(() => AuthCubit(sl()));
  sl.registerFactory<EtudiantCubit>(() => EtudiantCubit(sl()));
  sl.registerFactory<DeleteEtudiantCubit>(() => DeleteEtudiantCubit(sl()));
  sl.registerFactory<ArchiveEtudiantCubit>(() => ArchiveEtudiantCubit(sl()));
  sl.registerLazySingleton<ProfRepo>(() => ProfRepo(sl<DioHelper>()));
  sl.registerLazySingleton<TableauBordApi>(
    () => TableauBordApi(sl<DioHelper>()),
  );
  sl.registerFactory<CardsCubit>(() => CardsCubit(sl()));
  sl.registerFactory<NiveauCubit>(() => NiveauCubit(sl<TableauBordApi>()));
  sl.registerFactory<SpecialiteCubit>(
    () => SpecialiteCubit(sl<TableauBordApi>()),
  );
  sl.registerFactory<ChartCubit>(() => ChartCubit(sl<TableauBordApi>()));
  sl.registerLazySingleton(() => ProfilApi(sl()));

  sl.registerFactory(() => ProfileCubit(sl()));

  sl.registerLazySingleton<NotificationHistoriqueRepo>(
    () => NotificationHistoriqueRepo(sl<DioHelper>()),
  );
  sl.registerLazySingleton<ScolariteRepo>(() => ScolariteRepo(sl<DioHelper>()));
  sl.registerFactory<GetNotificationsCubit>(() => GetNotificationsCubit(sl()));
  sl.registerFactory<DeleteProfCubit>(() => DeleteProfCubit(sl()));
  sl.registerFactory<MarkAsReadCubit>(() => MarkAsReadCubit(sl()));
  sl.registerFactory<SendNotificationCubit>(() => SendNotificationCubit(sl()));

  sl.registerLazySingleton<ChangePasswordApi>(
    () => ChangePasswordApi(sl<DioHelper>()),
  );

  sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(sl()));

  sl.registerLazySingleton<LogoutApi>(() => LogoutApi(sl<DioHelper>()));
  sl.registerLazySingleton<UpdateEtudiantCubit>(
    () => UpdateEtudiantCubit(sl()),
  );
  sl.registerLazySingleton<AddEtudiantCubit>(() => AddEtudiantCubit(sl()));
  sl.registerFactory<Archeiveliste>(() => Archeiveliste(sl()));
  sl.registerFactory<UpdateProfCubit>(() => UpdateProfCubit(sl()));
  sl.registerFactory<ProfCubit>(() => ProfCubit(sl()));
  sl.registerFactory<AddProfCubit>(() => AddProfCubit(sl()));
  sl.registerFactory<ArchiveProfCubit>(() => ArchiveProfCubit(sl()));
  sl.registerFactory<DesarchiveCubit>(() => DesarchiveCubit(sl()));
  sl.registerFactory<LogoutCubit>(() => LogoutCubit(sl()));

  sl.registerLazySingleton<EmploiApi>(() => EmploiApi(sl<DioHelper>()));
  sl.registerFactory<EmploiCubit>(() => EmploiCubit(sl()));

  sl.registerLazySingleton<ExclusionRepo>(() => ExclusionRepo(sl<DioHelper>()));

  sl.registerFactory<ExclusionCubit>(() => ExclusionCubit(sl()));
  sl.registerFactory<ArcheiveProfliste>(() => ArcheiveProfliste(sl()));
  sl.registerFactory<DesarchiveProfCubit>(() => DesarchiveProfCubit(sl()));
  sl.registerFactory<ActionExclusionCubit>(() => ActionExclusionCubit(sl()));
  sl.registerFactory<ScolariteCubit>(() => ScolariteCubit(sl()));
  sl.registerFactory<UpdateScolariteCubit>(() => UpdateScolariteCubit(sl()));
  sl.registerFactory<DeleteScolariteCubit>(() => DeleteScolariteCubit(sl()));
  sl.registerFactory<AddScolariteCubit>(() => AddScolariteCubit(sl()));
  sl.registerFactory<SeuilCubit>(() => SeuilCubit(sl()));

  sl.registerLazySingleton<ImportSallesApi>(
    () => ImportSallesApi(sl<DioHelper>()),
  );
  sl.registerFactory<ImportSallesCubit>(() => ImportSallesCubit(sl()));

  sl.registerLazySingleton<ImportMatieresApi>(
    () => ImportMatieresApi(sl<DioHelper>()),
  );
  sl.registerFactory<ImportMatieresCubit>(() => ImportMatieresCubit(sl()));

  sl.registerLazySingleton<ImportEmploiApi>(
    () => ImportEmploiApi(sl<DioHelper>()),
  );
  sl.registerFactory<ImportEmploiCubit>(() => ImportEmploiCubit(sl()));

  sl.registerLazySingleton<ImportExamenApi>(
    () => ImportExamenApi(sl<DioHelper>()),
  );
  sl.registerFactory<ImportExamenCubit>(() => ImportExamenCubit(sl()));

  sl.registerLazySingleton<ImportEtudiantApi>(() => ImportEtudiantApi(sl<DioHelper>()));
sl.registerFactory<ImportEtudiantCubit>(() => ImportEtudiantCubit(sl()));

sl.registerLazySingleton<ImportProfApi>(() => ImportProfApi(sl<DioHelper>()));
sl.registerFactory<ImportProfCubit>(() => ImportProfCubit(sl()));
}
