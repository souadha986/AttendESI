import 'package:admin/core/assets/images.dart';
import 'package:admin/core/navigation/app_routes.dart';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/utils/secire_storage.dart';
import 'package:admin/core/utils/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 1, milliseconds: 50),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    controller.repeat(reverse: true);
    navigation();
  }

  Future<void> navigation() async {
    await Future.delayed(Duration(seconds: 3));
    sl<SecureStorage>().getaccessToken().then((value) {
      if (value != null && value.isNotEmpty) {
        context.goNamed(AppRoutes.mainscreen);
      } else {
        context.goNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: ScaleTransition(
          scale: animation,
          child: SvgPicture.asset(Images.splash, height: 500.h, width: 500.w),
        ),
      ),
    );
  }
}
