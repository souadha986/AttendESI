import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class ShowSnackBar {
  static void showAnimatedSnackDialog({
    required BuildContext context,
    required String? message,
    required AnimatedSnackBarType? type,
  }) {
    AnimatedSnackBar.material(
      message ?? "",
      type: type ?? AnimatedSnackBarType.success,
      mobileSnackBarPosition:
          MobileSnackBarPosition.bottom, // Position for mobile
      desktopSnackBarPosition:
          DesktopSnackBarPosition.topRight, // Position for desktop
    ).show(context);
  }
}