import 'package:admin/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData icon;
  final bool isLoading;

  const CreateAccountButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: Icon(icon, size: 22.sp, color: const Color(0xFF828282)),
      label: Text(
        isLoading ? "Importation en cours..." : text,
        style: AppStyles.black25w500.copyWith(
          color: const Color(0xFF7B7B7B),
          fontSize: 16.sp,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        side: const BorderSide(color: Color(0xFF06A1F1), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        backgroundColor: const Color(0xFFE4EEFA),
      ),
    );
  }
}
