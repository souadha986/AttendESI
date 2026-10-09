import 'package:admin/core/assets/images.dart';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

enum SidebarRoute {
  tableauDeBord,
  etudiant,
  archeivertudiant,
  archeiveprof,
  enseignant,
  serviceScolarite,
  emploiDuTemps,
  exclusions,
  parametres,
  historiqueNotification,
  profile,
}

// ─────────────────────────────────────────────
// MAIN SIDEBAR WIDGET
// ─────────────────────────────────────────────

class AttendESISidebar extends StatelessWidget {
  final SidebarRoute selectedRoute;
  final ValueChanged<SidebarRoute> onRouteSelected;

  const AttendESISidebar({
    super.key,
    required this.selectedRoute,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312.w,
      height: double.infinity,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFEEEEEE), width: 1)),
        color: Colors.white,
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
          _SidebarHeader(),

          HeightSpace(16),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          HeightSpace(10),

          _NavItem(
            icon: Icons.dashboard_outlined,
            label: 'Tableau de Bord',
            route: SidebarRoute.tableauDeBord,
            selected:
                selectedRoute == SidebarRoute.tableauDeBord ||
                selectedRoute == SidebarRoute.profile,
            onTap: () => onRouteSelected(SidebarRoute.tableauDeBord),
          ),
          HeightSpace(4),

          _GroupHeader(label: 'Comptes utilisateurs'),

          _NavItem(
            icon: Icons.school_outlined,
            label: 'Etudiant',
            route: SidebarRoute.etudiant,
            selected:
                selectedRoute == SidebarRoute.etudiant ||
                selectedRoute == SidebarRoute.archeivertudiant,
            onTap: () => onRouteSelected(SidebarRoute.etudiant),
            isActive: true,
          ),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Enseignant',
            route: SidebarRoute.enseignant,
            selected:
                selectedRoute == SidebarRoute.enseignant ||
                selectedRoute == SidebarRoute.archeiveprof,
            onTap: () => onRouteSelected(SidebarRoute.enseignant),
          ),
          _NavItem(
            icon: Icons.business_outlined,
            label: 'Service de Scolarite',
            route: SidebarRoute.serviceScolarite,
            selected: selectedRoute == SidebarRoute.serviceScolarite,
            onTap: () => onRouteSelected(SidebarRoute.serviceScolarite),
          ),

          HeightSpace(4),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          HeightSpace(4),

          _NavItem(
            icon: Icons.calendar_today_outlined,
            label: 'Emploi du temps',
            route: SidebarRoute.emploiDuTemps,
            selected: selectedRoute == SidebarRoute.emploiDuTemps,
            onTap: () => onRouteSelected(SidebarRoute.emploiDuTemps),
          ),
          _NavItem(
            icon: Icons.block_outlined,
            label: 'Exclusions',
            route: SidebarRoute.exclusions,
            selected: selectedRoute == SidebarRoute.exclusions,
            onTap: () => onRouteSelected(SidebarRoute.exclusions),
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            label: 'Paramètres',
            route: SidebarRoute.parametres,
            selected: selectedRoute == SidebarRoute.parametres,
            onTap: () => onRouteSelected(SidebarRoute.parametres),
          ),

          HeightSpace(4),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          HeightSpace(4),

          _NavItem(
            icon: Icons.notifications_none_outlined,
            label: 'Historique de Notification',
            route: SidebarRoute.historiqueNotification,
            selected: selectedRoute == SidebarRoute.historiqueNotification,
            onTap: () => onRouteSelected(SidebarRoute.historiqueNotification),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────

class _SidebarHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: Row(
        children: [
          Container(
            width: 120.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SvgPicture.asset(Images.splash, fit: BoxFit.cover),
          ),
          Text(
            'Dashboard',
            style: AppStyles.white20w700.copyWith(color: Color(0xFF0969BB)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// GROUP LABEL
// ─────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final String label;
  const _GroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          Icon(Icons.people_outline, size: 23.sp, color: Color(0xFF666666)),
          WidthSpace(6),
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Color(0xFF666666),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// NAV ITEM
// ─────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final SidebarRoute route;
  final bool selected;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.selected,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
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
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
          decoration: BoxDecoration(
            color: widget.selected
                ? const Color(0xFF1062FB)
                : _hovering
                ? const Color(0xFFE4EEFA)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18.sp,
                color: widget.selected ? Colors.white : const Color(0xFF444444),
              ),
              WidthSpace(10),
              Expanded(
                child: Text(
                  widget.label,
                  style: AppStyles.grey20w500.copyWith(
                    fontSize: 14.sp,
                    fontWeight: widget.selected
                        ? FontWeight.w600
                        : FontWeight.bold,
                    color: widget.selected
                        ? Colors.white
                        : const Color(0xFF7B7B7B),
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
