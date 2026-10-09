import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prof/core/styling/app_colors.dart';

class AppStyles {
  static TextStyle white24w600 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 24.sp,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle white15w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 15.sp,
      color: AppColors.whiteColor,
      fontWeight: FontWeight.w700,
    ),
  );
  static TextStyle black25w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 25.sp,
      color: Color(0xFF454545),
      fontWeight: FontWeight.w700,
    ),
  );
  static TextStyle black15w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 15.sp,
      color: Color(0xFF454545),
      fontWeight: FontWeight.bold,
    ),
  );
  static TextStyle black13w500 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 13.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle black15w600 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 15.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle black12w300 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 12.sp,
      color: AppColors.blackColor,
      fontWeight: FontWeight.w300,
    ),
  );
  static TextStyle grey20w500 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 20.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle grey14w600 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 14.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle grey14w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 14.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.w700,
    ),
  );
  static TextStyle grey16w500 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle blueA15w500 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 15.sp,
      color: Color(0xFF123A7A),
      fontWeight: FontWeight.w500,
    ),
  );
  static TextStyle blueA20w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 20.sp,
      color: Color(0xFF123A7A),
      fontWeight: FontWeight.w700,
    ),
  );
  static TextStyle blue14w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 14.sp,
      color: Color(0xFF1F3352),
      fontWeight: FontWeight.w700,
    ),
  );

  static TextStyle blueF13w900 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 13.sp,
      color: AppColors.bleuColorF,
      fontWeight: FontWeight.w900,
    ),
  );
  static TextStyle blue13w900 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 13.sp,
      color: AppColors.bleuColor2,
      fontWeight: FontWeight.w900,
    ),
  );
  static TextStyle red13w900 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 13.sp,
      color: Color(0xFFF56764),
      fontWeight: FontWeight.w900,
    ),
  );
  static TextStyle gridtext = GoogleFonts.poppins(
    fontSize: 25.sp,
    fontWeight: FontWeight.w700,
    foreground: Paint()
      ..shader = LinearGradient(
        colors: [AppColors.blueColorE, Color(0xFF03B1EE)],
      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
  );
  TextStyle gradientTextStyle = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.5,
    foreground: Paint()
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xFF828282), Color(0xFF454545)],
        stops: [0.14, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, 100, 21)),
  );
}
