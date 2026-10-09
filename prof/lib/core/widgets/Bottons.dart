import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Bottons extends StatelessWidget {
  final double? width;
  final double? height;
  final double? radius;
  final TextStyle? textstyle;
  final String? title;
  final List<Color>? gradientColors;
  final bool isloading;
  final void Function() onPress;

  const Bottons({
    this.isloading = false,
    super.key,
    this.title,
    this.gradientColors,
    this.height,
    this.width,
    this.radius,
    this.textstyle,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    // Colors matching your design
    final List<Color> defaultGradient = [
      const Color(0xFF1351FE), // blueColorE
      const Color(0xFF04AAEF), // bleuColor1
    ];

    return Container(
      width: width ?? 380.w,
      height: height ?? 55.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 15.r),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: gradientColors ?? defaultGradient,
        ),
      ),
      child: ElevatedButton(
        onPressed: isloading ? null : onPress,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 15.r),
          ),
        ),
        child: isloading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Text(title ?? "", style: textstyle),
      ),
    );
  }
}
