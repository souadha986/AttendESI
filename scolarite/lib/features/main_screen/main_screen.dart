import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scolarite/core/navigation/app_routes.dart';
import 'package:scolarite/core/styling/app_colors.dart';
import 'package:scolarite/core/utils/service_locator.dart';
import 'package:scolarite/core/utils/snack_bar.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/absences/absences_screen.dart';
import 'package:scolarite/features/absences/cubit/absences_cubit.dart';
import 'package:scolarite/features/absences/cubit/absences_validate_cubit.dart';
import 'package:scolarite/features/absences/cubit/filtre_cubit.dart';
import 'package:scolarite/features/contact_admin/contact_admin_screen.dart';
import 'package:scolarite/features/dashboard/dashboard_screen.dart';
import 'package:scolarite/features/historique_notification/cubit/notif_cubit.dart';
import 'package:scolarite/features/historique_notification/historique_notification_screen.dart';
import 'package:scolarite/features/justificatifs/cubit/deaitls_cubit.dart';
import 'package:scolarite/features/justificatifs/cubit/justificatif_cubit.dart';
import 'package:scolarite/features/justificatifs/justicatifs_screen.dart';
import 'package:scolarite/features/main_screen/cubit/logout_cubit.dart';
import 'package:scolarite/features/main_screen/cubit/logout_state.dart';
import 'package:scolarite/features/modifier_absences/cubit/absence_modif_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/modif_liste_cubit.dart';
import 'package:scolarite/features/modifier_absences/cubit/modifier_cubit.dart';
import 'package:scolarite/features/modifier_absences/modifier_absence_screen.dart';
import 'package:scolarite/features/planning/cubit/exam_cubit.dart';
import 'package:scolarite/features/planning/cubit/planning_cubit.dart';
import 'package:scolarite/features/planning/planning_screen.dart';
import 'package:scolarite/features/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  final List<Map<String, dynamic>> menuItems = [
    {"label": "Tableau de Bord", "icon": Icons.dashboard_outlined},
    {"label": "Justificatifs", "icon": Icons.description_outlined},
    {"label": "Planning", "icon": Icons.calendar_today_outlined},
    {"label": "Absences", "icon": Icons.person_off_outlined},
    {"label": "Modifier Absence", "icon": Icons.edit_outlined},
    {"label": "Profil", "icon": Icons.person_outline},
    {"label": "Contacter Admin", "icon": Icons.mail_outline},
    {
      "label": "Historique de Notifications",
      "icon": Icons.notifications_none_outlined,
    },
  ];

  Widget getPage() {
    switch (selectedIndex) {
      case 0:
        return DashboardScreen();
      case 1:
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<JustificatifsCubit>()..fetchAllJustificatifs(),
            ),
            BlocProvider(create: (_) => sl<JustificatifDetailsCubit>()),
          ],
          child: JusticatifsScreen(),
        );
      case 2:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<PlanningCubit>()),
            BlocProvider(create: (_) => sl<ExamCubit>()),
          ],
          child: PlanningScreen(),
        );
      case 3:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<FiltreCubit>()..getFiltres()),
            BlocProvider(create: (_) => sl<AbsenceCubit>()),
            BlocProvider(create: (_) => sl<AbsencesValidateCubit>()),
          ],
          child: AbsencesScreen(),
        );
      case 4:
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<AbsenceModifCubit>()),
            BlocProvider(create: (_) => sl<ModifListeCubit>()),
            BlocProvider(create: (_) => sl<ModifierCubit>()),
          ],
          child: ModifierAbsenceScreen(),
        );
      case 5:
        return ProfileScreen();
      case 6:
        return ContactAdminScreen();
      case 7:
        return BlocProvider(
          create: (context) => sl<NotifCubit>()..getNotifications(),
          child: HistoriqueNotificationScreen(),
        );
      default:
        return const Center(child: Text("Page"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (selectedIndex != 0) {
          setState(() => selectedIndex = 0);
        } else {
          if (!kIsWeb) {
            SystemNavigator.pop();
          } else {
            context.read<LogoutCubit>().logout();
          }
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xffFAFCFE),
        body: BlocProvider<LogoutCubit>(
          create: (context) => sl<LogoutCubit>(),
          child: BlocConsumer<LogoutCubit, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccessState) {
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.message,
                  type: AnimatedSnackBarType.success,
                );
                context.goNamed(AppRoutes.login);
              }
              if (state is LogoutErrorState) {
                ShowSnackBar.showAnimatedSnackDialog(
                  context: context,
                  message: state.error,
                  type: AnimatedSnackBarType.error,
                );
              }
            },
            builder: (context, logoutState) {
              return Row(
                children: [
                  // ── SIDEBAR ───────────────────────────────────
                  Container(
                    width: 250.w,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        right: BorderSide(
                          color: const Color(0xFFEEEEEE),
                          width: 1,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16.r,
                          offset: const Offset(2, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeightSpace(20),
                        // ── Header ──────────────────────────────
                        Padding(
                          padding: EdgeInsets.only(
                            top: 30.h,
                            left: 20.w,
                            bottom: 16.h,
                          ),
                          child: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Color(0xFF96BAE4), Color(0xFF0969BB)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ).createShader(bounds),
                            child: Text(
                              "Service de scolarité",
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        HeightSpace(18),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        HeightSpace(10),

                        // ── Menu items ───────────────────────────
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: menuItems.length,
                            itemBuilder: (context, index) {
                              final isSelected = selectedIndex == index;
                              final item = menuItems[index];
                              return _SidebarNavItem(
                                icon: item["icon"] as IconData,
                                label: item["label"] as String,
                                selected: isSelected,
                                onTap: () {
                                  setState(() => selectedIndex = index);
                                  context.go('/mainScreen?tab=$index');
                                },
                              );
                            },
                          ),
                        ),

                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        HeightSpace(20),

                        // ── Logout ───────────────────────────────
                        Padding(
                          padding: EdgeInsets.only(bottom: 30.h, left: 20.w),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.r),
                            onTap: logoutState is LogoutLoadingState
                                ? null
                                : () => context.read<LogoutCubit>().logout(),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 10.h,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout_rounded,
                                    color: AppColors.red,
                                    size: 18.sp,
                                  ),
                                  WidthSpace(10),
                                  Text(
                                    "Déconnexion",
                                    style: GoogleFonts.poppins(
                                      color: AppColors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── CONTENT AREA ──────────────────────────────
                  Expanded(child: getPage()),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
//  Sidebar Nav Item 
// ─────────────────────────────────────────────────────────────────
class _SidebarNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          decoration: BoxDecoration(
            color: widget.selected
                ? const Color(0xFF1062FB)
                : _hovering
                ? const Color(0xFFE4EEFA)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18.sp,
                color: widget.selected ? Colors.white : const Color(0xFF454545),
              ),
              WidthSpace(10),
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: widget.selected
                        ? FontWeight.w700
                        : FontWeight.w600,
                    color: widget.selected
                        ? Colors.white
                        : const Color(0xFF454545),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
