import 'dart:async';

import 'package:admin/core/utils/service_locator.dart';
import 'package:admin/features/emploi/cubit/emploi_cubit.dart';
import 'package:admin/features/emploi/cubit/import_emploi_cubit.dart';
import 'package:admin/features/emploi/cubit/import_examen_cubit.dart';
import 'package:admin/features/emploi/emploi_screen.dart';
import 'package:admin/features/exclusion/cubit/action_exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/exclusion_cubit.dart';
import 'package:admin/features/exclusion/cubit/seuil_cubit.dart';
import 'package:admin/features/exclusion/exclusion_screen.dart';
import 'package:admin/features/exclusion/repo/exclusion_repo.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/add_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/archive_etudiant_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/delete_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/desarchive_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/import_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/liste_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/cubit/update_etudiant_cubit.dart';
import 'package:admin/features/gestion_comptes/etudiant/etudiant.dart';
import 'package:admin/features/gestion_comptes/etudiant/widget/archeive_etudiant.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/add_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/archive_prof_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/delete_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/desarchive_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/import_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/liste_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/cubit/cubit/update_prof_cubit.dart';
import 'package:admin/features/gestion_comptes/prof/prof.dart';
import 'package:admin/features/gestion_comptes/prof/widget/archeive_prof.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/add_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/delete_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/scolarite_liste_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/cubit/update_scolarite_cubit.dart';
import 'package:admin/features/gestion_comptes/scolarite/scolarite.dart';
import 'package:admin/features/historique_notification/cubit/mark_read_cubit.dart';
import 'package:admin/features/historique_notification/cubit/notification_cubit.dart';
import 'package:admin/features/historique_notification/cubit/reply_cubit.dart';
import 'package:admin/features/historique_notification/historique_notification_screen.dart';
import 'package:admin/features/main_screen/widget/side_bar.dart';
import 'package:admin/features/parametre/cubit/change_mdp_cubit.dart';
import 'package:admin/features/parametre/cubit/import_matieres_cubit.dart';
import 'package:admin/features/parametre/cubit/import_salles_cubit.dart';
import 'package:admin/features/parametre/cubit/logout_cubit.dart';
import 'package:admin/features/parametre/parametre_screen.dart';
import 'package:admin/features/tableau_board/cubit/cards_cubit.dart';
import 'package:admin/features/tableau_board/cubit/chart_cubit.dart';
import 'package:admin/features/tableau_board/cubit/niveau_cubit.dart';
import 'package:admin/features/tableau_board/cubit/profile_cubit.dart';
import 'package:admin/features/tableau_board/cubit/specialite_cubit.dart';
import 'package:admin/features/tableau_board/profil_screen.dart';
import 'package:admin/features/tableau_board/tableau_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MinScreenState();
}

class _MinScreenState extends State<MainScreen> {
  SidebarRoute _currentRoute = SidebarRoute.tableauDeBord;
  String? _adminName;
  Timer? _refreshTimer;

  // Cubits du tableau de bord créés une seule fois
  late final CardsCubit _cardsCubit = sl<CardsCubit>();
  late final NiveauCubit _niveauCubit = sl<NiveauCubit>();
  late final SpecialiteCubit _specialiteCubit = sl<SpecialiteCubit>();
  late final ChartCubit _chartCubit = sl<ChartCubit>();
  late final ProfileCubit _profileCubit = sl<ProfileCubit>();

@override
void initState() {
  super.initState();

  // Tous les appels en parallèle
  Future.wait([
    _profileCubit.refreshProfile(),
    _cardsCubit.refreshCards(),
    _niveauCubit.getNiveaux(),
    _specialiteCubit.getSpecialites(),
    Future(() => _chartCubit.getChart(niveau: "1CPI", specialite: null)),
  ]);

  _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
    Future.wait([
      _profileCubit.refreshProfile(),
      _cardsCubit.refreshCards(),
      _niveauCubit.getNiveaux(),
      _specialiteCubit.getSpecialites(),
      Future(() => _chartCubit.getChart(niveau: "1CPI", specialite: null)),
    ]);
  });
}

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cardsCubit),
        BlocProvider.value(value: _niveauCubit),
        BlocProvider.value(value: _specialiteCubit),
        BlocProvider.value(value: _chartCubit),
        BlocProvider.value(value: _profileCubit),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        body: Row(
          children: [
            AttendESISidebar(
              selectedRoute: _currentRoute,
              onRouteSelected: (route) => setState(() => _currentRoute = route),
            ),
            Expanded(child: _buildPage(_currentRoute)),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(SidebarRoute route) {
    switch (route) {
      case SidebarRoute.tableauDeBord:
        return TableauBoardScreen(
          onProfileTap: (adminName) {
            setState(() {
              _adminName = adminName;
              _currentRoute = SidebarRoute.profile;
            });
          },
        );
      case SidebarRoute.profile:
        return ProfilScreen(
          adminName: _adminName ?? "",
          onBack: () =>
              setState(() => _currentRoute = SidebarRoute.tableauDeBord),
        );


      case SidebarRoute.etudiant:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<EtudiantCubit>()),
            BlocProvider(create: (context) => sl<DeleteEtudiantCubit>()),
            BlocProvider(create: (context) => sl<ArchiveEtudiantCubit>()),
            BlocProvider(create: (context) => sl<UpdateEtudiantCubit>()),
            BlocProvider(create: (context) => sl<AddEtudiantCubit>()),
            BlocProvider(create: (context) => sl<ImportEtudiantCubit>()),
          ],
          child: Etudiant(
            onArchiveTap: () {
              print("Navigating to Archive..."); // Check your console for this!

              setState(() {
                _currentRoute = SidebarRoute.archeivertudiant;
              });
            },
          ),
        );

      case SidebarRoute.archeivertudiant:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<Archeiveliste>()..loadEtudiants(),
            ),
            BlocProvider(create: (context) => sl<DesarchiveCubit>()),
          ],
          child: ArcheiveEtuudiant(
            onBack: () {
              setState(() {
                _currentRoute = SidebarRoute.etudiant;
              });
            },
          ),
        );

      case SidebarRoute.enseignant:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<ProfCubit>()),
            BlocProvider(create: (context) => sl<DeleteProfCubit>()),
            BlocProvider(create: (context) => sl<ArchiveProfCubit>()),
            BlocProvider(create: (context) => sl<UpdateProfCubit>()),
            BlocProvider(create: (context) => sl<AddProfCubit>()),
            BlocProvider(create: (context) => sl<ArcheiveProfliste>()),
            BlocProvider(create: (context) => sl<ImportProfCubit>()),
          ],
          child: ProfPage(
            onArchiveTap: () {
           //   print("Navigating to Archive..."); // Check your console for this!
              setState(() {
                _currentRoute = SidebarRoute.archeiveprof;
              });
            },
          ),
        );

      case SidebarRoute.archeiveprof:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => sl<ArcheiveProfliste>()..loadProfs(),
            ),
            BlocProvider(create: (context) => sl<DesarchiveProfCubit>()),
          ],
          child: ArcheiveProf(
            onBack: () {
              setState(() {
                _currentRoute = SidebarRoute.enseignant;
              });
            },
          ),
        );

      case SidebarRoute.serviceScolarite:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<ScolariteCubit>()),
            BlocProvider(create: (context) => sl<DeleteScolariteCubit>()),

            BlocProvider(create: (context) => sl<UpdateScolariteCubit>()),
            BlocProvider(create: (context) => sl<AddScolariteCubit>()),
          ],
          child: ScolaritePage(),
        );
      case SidebarRoute.emploiDuTemps:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<EmploiCubit>()),
            BlocProvider(create: (_) => sl<ImportEmploiCubit>()),
            BlocProvider(create: (_) => sl<ImportExamenCubit>()),
          ],
          child: const EmploiScreen(),
        );
      case SidebarRoute.exclusions:
        return RepositoryProvider(
          create: (_) => sl<ExclusionRepo>(),
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (ctx) => sl<ExclusionCubit>()),
              BlocProvider(create: (ctx) => sl<SeuilCubit>()),
              BlocProvider(create: (ctx) => sl<ActionExclusionCubit>()),
            ],
            child: const ExclusionScreen(),
          ),
        );
      case SidebarRoute.parametres:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<ChangePasswordCubit>()),
            BlocProvider(create: (_) => sl<LogoutCubit>()),
            BlocProvider(create: (_) => sl<ImportSallesCubit>()),
            BlocProvider(create: (_) => sl<ImportMatieresCubit>()),
          ],
          child: const ParametreScreen(),
        );
      case SidebarRoute.historiqueNotification:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<GetNotificationsCubit>()..getNotifications(),
            ),
            BlocProvider(create: (_) => sl<MarkAsReadCubit>()),
            BlocProvider(create: (_) => sl<SendNotificationCubit>()),
          ],
          child: const HistoriqueNotificationScreen(),
        );
    }
  }
}
