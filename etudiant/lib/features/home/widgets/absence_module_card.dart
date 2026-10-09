import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModuleAbsenceCard extends StatelessWidget {
  final String moduleName;
  final double totalAbsencePercent;
  final double justifiedPercent;
  final bool isExclu;

  const ModuleAbsenceCard({
    super.key,
    required this.moduleName,
    required this.totalAbsencePercent,
    required this.justifiedPercent,
    this.isExclu = false,
  });

  bool get _isDanger => totalAbsencePercent > 50 || justifiedPercent > 50;

  Color get _cardColor => isExclu
      ? const Color(0xFFFEF2F2)
      : _isDanger
      ? const Color(0xFFFEF2F2)
      : const Color(0xFFE4EEFA);

  Color get _totalBarColor => totalAbsencePercent > 50
      ? const Color(0xFFF56764)
      : const Color(0xFF9DD4FF);

  Color get _totalLabelColor => totalAbsencePercent > 50
      ? const Color(0xFFF56764)
      : const Color(0xFF9DD4FF);

  Color get _justifiedBarColor =>
      justifiedPercent > 50 ? const Color(0xFFF56764) : const Color(0xFF3796E2);

  Color get _justifiedLabelColor =>
      justifiedPercent > 50 ? const Color(0xFFF56764) : const Color(0xFF3796E2);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12.r),
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
          HeightSpace(6),
          Text(moduleName, style: AppStyles.black15w700),
          if (isExclu) ...[
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.block_rounded,
                  color: const Color(0xFFF56764),
                  size: 14.sp,
                ),
                WidthSpace(6),
                Expanded(
                  child: Text(
                    "Vous avez été exclu de ce module.",
                    style: AppStyles.black15w700.copyWith(
                      fontSize: 11.sp,
                      color: const Color(0xFFF56764),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ] else ...[
            HeightSpace(14),
            _AbsenceBar(
              percent: totalAbsencePercent,
              color: _totalBarColor,
              label: "${totalAbsencePercent.toInt()}%",
              labelColor: _totalLabelColor,
            ),
            HeightSpace(10),
            _AbsenceBar(
              percent: justifiedPercent,
              color: _justifiedBarColor,
              label: "${justifiedPercent.toInt()}%",
              labelColor: _justifiedLabelColor,
            ),
          ],
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
            minHeight: 6.h,
          ),
        ),
        HeightSpace(6),
        Text(label, style: AppStyles.blueF13w900.copyWith(color: labelColor)),
      ],
    );
  }
}
