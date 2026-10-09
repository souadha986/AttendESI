import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class myOutlinedBottom extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final TextStyle? textstyle;
  final String? title;
  final bool isloading;
  final void Function() onPress;

  const myOutlinedBottom({
    this.isloading = false,
    super.key,
    this.title,
    this.height,
    this.width,
    this.radius,
    this.textstyle,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    // Defining the specific blue color from your image
    const Color brandBlue = Color(0xFF098FF4);

    return SizedBox(
      width: width ?? 380.w,
      height: height ?? 55.h,
      child: OutlinedButton(
        onPressed: isloading ? null : onPress,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,

          side: const BorderSide(color: brandBlue, width: 1.5),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 20.r),
          ),
          elevation: 0,
        ),
        child: isloading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.0,
                  valueColor: AlwaysStoppedAnimation<Color>(brandBlue),
                ),
              )
            : Text(
                title ?? "",
                style:
                    textstyle ??
                    TextStyle(
                      color: brandBlue,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
              ),
      ),
    );
  }
}
