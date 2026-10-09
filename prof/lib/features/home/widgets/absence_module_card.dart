import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';

class ModuleAbsenceCard extends StatelessWidget {
  final String moduleName;
  final double totalAbsencePercent;
  final double justifiedPercent;
  final String niveau;
  final String specialite;
  final String groupe;

  const ModuleAbsenceCard({
    super.key,
    required this.moduleName,
    required this.totalAbsencePercent,
    required this.justifiedPercent,
    required this.niveau,
    required this.specialite,
    required this.groupe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Color(0xFFE4EEFA),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Module name ──────────────────────────────────────
          Text(
            moduleName,
            style: AppStyles.grey14w600.copyWith(
              fontSize: 19.sp,
              color: Color(0xFF454545),
            ),
          ),

          HeightSpace(6),

          // ── Niveau ──────────────────────────────────────────
          Row(
            children: [
              Text(
                "Niveau: ",
                style: AppStyles.blueA15w500.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                niveau,
                style: AppStyles.black15w700.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          HeightSpace(3),

          // ── Spécialité ───────────────────────────────────────
          Row(
            children: [
              Text(
                "spécialité: ",
                style: AppStyles.blueA15w500.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                specialite,
                style: AppStyles.black15w700.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          HeightSpace(3),

          // ── Groupe ───────────────────────────────────────────
          Row(
            children: [
              Text(
                "Groupe: ",
                style: AppStyles.blueA15w500.copyWith(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                groupe,
                style: AppStyles.black15w700.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          HeightSpace(12),

          _AbsenceBar(
            percent: totalAbsencePercent,
            color: Color(0xFF9DD4FF),
            label: "${totalAbsencePercent.toInt()}%",
            labelColor: Color(0xFF9DD4FF),
          ),

          HeightSpace(10),

          // ── Justified bar ────────────────────────────────────
          _AbsenceBar(
            percent: justifiedPercent,
            color: Color(0xFF3796E2),
            label: "${justifiedPercent.toInt()}%",
            labelColor: Color(0xFF3796E2),
          ),
        ],
      ),
    );
  }
}

class _AbsenceBar extends StatelessWidget {
  final double percent;
  final Color color;
  final String label;
  final Color labelColor;

  const _AbsenceBar({
    required this.percent,
    required this.color,
    required this.label,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: LinearProgressIndicator(
            value: (percent / 100).clamp(0.0, 1.0),
            backgroundColor: Colors.white.withOpacity(0.6),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 15.h,
          ),
        ),
        HeightSpace(6),
        Text(label, style: AppStyles.blueF13w900.copyWith(color: labelColor)),
      ],
    );
  }
}
