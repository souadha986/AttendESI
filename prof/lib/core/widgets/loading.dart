
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:prof/core/assets/images.dart';

class Loading extends StatelessWidget {
  final double? height;
  final double? weight;
  const Loading({super.key, this.height, this.weight});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height ?? 250.h,
        width: weight ?? 250.w,
        child: Center(child: Lottie.asset(Images.loadingAnimation)),
      ),
    );
  }
}