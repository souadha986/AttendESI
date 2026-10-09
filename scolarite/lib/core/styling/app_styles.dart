import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scolarite/core/styling/app_colors.dart';

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
  /////////////////////////////////////////////////////
  static TextStyle blueBBw800 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 21.sp,
      color: Color(0xff0969BB),
      fontWeight: FontWeight.w800,
    ),
  );
  static TextStyle blueDBw800 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 17.sp,
      color: Color(0xff4B82DB),
      fontWeight: FontWeight.w800,
    ),
  );
  static TextStyle grey13w700 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 13.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.w700,
    ),
  );

  static TextStyle black16wBold = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 15.sp,
      color: Color(0xFF4C4C4D),
      fontWeight: FontWeight.bold,
    ),
  );
  static TextStyle grey13Bold = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 12.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.bold,
    ),
  );
  static TextStyle black45Bold = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 17.sp,
      color: Color(0xFF454545),
      fontWeight: FontWeight.bold,
    ),
  );
  static TextStyle black45Bold12 = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 12.sp,
      color: Color(0xFF454545),
      fontWeight: FontWeight.bold,
    ),
  );
  static TextStyle black3ASemiBold = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF3A3A3A),
      fontWeight: FontWeight.w600,
    ),
  );
  static TextStyle grey67Bold = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 16.sp,
      color: Color(0xFF676767),
      fontWeight: FontWeight.bold,
    ),
  );
  static TextStyle grey82Bold = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 14.sp,
      color: Color(0xFF828282),
      fontWeight: FontWeight.bold,
    ),
  );
  static TextStyle blackpetit = GoogleFonts.poppins(
    textStyle: TextStyle(
      fontSize: 10.sp,
      color: Color(0xFF454545),
      fontWeight: FontWeight.bold,
    ),
  );
}
