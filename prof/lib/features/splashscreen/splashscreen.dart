import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:prof/core/assets/images.dart';
import 'package:prof/core/navigation/app_routes.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'dart:async';

import 'package:prof/core/utils/secire_storage.dart';
import 'package:prof/core/utils/service_locator.dart';

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
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return; // ✅ Safety check
    final value = await sl<SecureStorage>().getaccessToken();
    if (!mounted) return; // ✅ Safety check after await
    if (value != null && value.isNotEmpty) {
      context.goNamed(AppRoutes.mainScreen);
    } else {
      context.goNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Center(
          child: ScaleTransition(
            scale: animation,
            child: SvgPicture.asset(Images.logo, height: 250.h, width: 250.w),
          ),
        ),
      ),
    );
  }
}
