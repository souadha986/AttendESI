// widgets/gradient_text.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const GradientText(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF135BFC), Color(0xFF1BB9EE)],
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        style:
            style ??
            GoogleFonts.inter(
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
      ),
    );
  }
}
