import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Fields extends StatefulWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final String? title;
  final double? width;
  final bool isPassword;
  const Fields({
    this.width,
    super.key,
    this.title,
    required this.isPassword,
    this.controller,
    this.validator,
  });

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  bool change = true;
  @override
  void initState() {
    super.initState();

    change = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: AppColors.blueColorE,
          selectionHandleColor: AppColors.blueColorE,
          selectionColor: AppColors.blueColorE.withOpacity(0.2),
        ),
      ),
      child: SizedBox(
        width: widget.width ?? 502.w,

        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: change,
          cursorColor: AppColors.blueColorE,
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: 12.sp),
            hintText: widget.title ?? "",
            hintStyle: AppStyles.grey20w500,
            contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(
                color: AppColors.verygreyColor,
                width: 1.w,
              ),
            ),
            fillColor: AppColors.greyColor,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: AppColors.greyColor, width: 1.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: Colors.red, width: 1.w),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: Colors.red, width: 1.w),
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        change = !change;
                      });
                    },
                    icon: Icon(
                      change ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.blackColor,
                      size: 20.sp, // Kept small but visible
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
