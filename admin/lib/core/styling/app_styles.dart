import 'package:admin/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static TextStyle white20w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 20.sp,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w700,
    ),
  );
  static TextStyle gridtext = GoogleFonts.poppins(
    fontSize: 30.sp,
    fontWeight: FontWeight.w700,
    foreground: Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF135BFC), Color(0xFF1BB9EE)],
      ).createShader(const Rect.fromLTWH(0.0, 0.0, 500.0, 50.0)),
  );

  static TextStyle black18w500 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 18.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle white24w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 24.sp,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w700,
    ),
  );
  static TextStyle black25w500 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 18.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle grey20w500 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 20.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle blueBB30w800 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 25.sp,
      color: Color(0xff0969BB),
      fontWeight: FontWeight.w800,
    ),
  );
  static TextStyle grey15w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 15.sp,
      color: Color(0xff828282),
      fontWeight: FontWeight.w700,
    ),
  );
  static TextStyle blueDBw800 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 17.sp,
      color: Color(0xff4B82DB),
      fontWeight: FontWeight.w800,
    ),
  );
  static TextStyle petitBlack = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 13.sp,
      color: const Color(0xff090909),
      fontWeight: FontWeight.w600,
    ),
  );
   static TextStyle black45Bold = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 17.sp,
      color: Color(0xFF454545),
      fontWeight: FontWeight.bold,
    ),
  );
}
