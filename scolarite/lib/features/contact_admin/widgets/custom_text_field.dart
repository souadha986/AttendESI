import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Label
        Padding(
          padding: EdgeInsets.only(left: 20.w),
          child: RichText(
            text: TextSpan(
              text: label,
              style: AppStyles.black3ASemiBold,
              children: [
                TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
        HeightSpace(8),

        /// Input
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          cursorColor: Color(0xff1351FE),
          style: GoogleFonts.poppins(fontSize: 14.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(color: Colors.grey, fontSize: 13.sp),

            filled: true,
            fillColor: Color(0xFFF0F7FE),
            hoverColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: maxLines > 1 ? 16.h : 0,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(33.r),
              borderSide: BorderSide.none,
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(33.r),
              borderSide: BorderSide(color: Color(0xff454545), width: 0.5),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(33.r),
              borderSide: BorderSide(color: Color(0xff1351FE), width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(33.r),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
