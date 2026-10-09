import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/assets/images.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';

class InformationCard extends StatelessWidget {
  final bool issick;
  final String fullname;
  final String matricule;
  final String? npresence;
  final String? nabsence;
  final String? njustifies;

  const InformationCard({
    super.key,
    required this.fullname,
    required this.matricule,
    required this.issick,
    required this.nabsence,
    required this.njustifies,
    required this.npresence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE4EEFA),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullname,
                  style: AppStyles.black13w500.copyWith(fontSize: 16.sp),
                ),
                Text(matricule, style: TextStyle(fontSize: 12.sp)),
              ],
            ),
          ),
          WidthSpace(18),
          issick
              ? Image.asset(Images.sick, width: 34.w, height: 34.h)
              : WidthSpace(12),
          _buildButton(npresence!, Color(0xFF9CD2ED)),
          WidthSpace(5),
          _buildButton(njustifies!, Color(0xFFB1DDC5)),
          WidthSpace(5),
          _buildButton(nabsence!, Color(0xFFF0B9B3)),
        ],
      ),
    );
  }
}

Widget _buildButton(String text, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 3.h),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(14.r),
    ),
    child: Text(
      text,
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
  );
}
