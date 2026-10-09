import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Scolarite {
  final String nom;
  final String prenom;
  final String email;
  final String cycleResponsable;

  Scolarite({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.cycleResponsable,
  });
}

class ScolaritesTable extends StatelessWidget {
  final List<Scolarite> Scolarites;
  final void Function(Scolarite Scolarite)? onSupprimer;
  final void Function(Scolarite Scolarite)? onModifier;

  const ScolaritesTable({
    super.key,
    required this.Scolarites,
    this.onSupprimer,
    this.onModifier,
  });

  @override
  Widget build(BuildContext context) {
    const double totalTableWidth = 1050;

    return Container(
      margin: EdgeInsets.all(20.w),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: totalTableWidth.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              Column(
                children: List.generate(
                  Scolarites.length,
                  (index) => _buildRow(Scolarites[index], index),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 15.w),
      color: const Color(0xFFE4EEFA),
      child: Row(
        children: [
          _cell("Nom", width: 150.w, isHeader: true),
          _cell("Prénom", width: 150.w, isHeader: true),
          _cell("Email", width: 220.w, isHeader: true),
          _cell("Cycle", width: 200.w, isHeader: true),
          _cell("Actions", width: 220.w, isHeader: true),
        ],
      ),
    );
  }

  Widget _buildRow(Scolarite s, int index) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
      decoration: BoxDecoration(
        color: index % 2 == 0 ? Colors.white : const Color(0xFFF8FAFC),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 0.8),
        ),
      ),
      child: Row(
        children: [
          _cell(s.nom, width: 150.w),
          _cell(s.prenom, width: 150.w),
          _cell(s.email, width: 220.w),
          _cell(s.cycleResponsable, width: 150.w),

          SizedBox(width: 220.w, child: _actions(s)),
        ],
      ),
    );
  }

  Widget _cell(String text, {required double width, bool isHeader = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: AppStyles.white20w700.copyWith(
          color: isHeader ? const Color(0xFF7B7B7B) : AppColors.blackColor,
          fontSize: isHeader ? 14.sp : 13.sp,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _actions(Scolarite Scolarite) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 50.w),
        _buildActionButton(
          "Supprimer",
          const Color(0xFFE15252),
          onTap: () => onSupprimer?.call(Scolarite),
        ),
        SizedBox(width: 50.w),
        _buildActionButton(
          "Modifier",
          const Color(0xFF0084FF),
          onTap: () => onModifier?.call(Scolarite),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    Color backgroundColor, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
