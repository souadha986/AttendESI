import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_transitions/go_transitions.dart';

import 'package:intl/date_symbol_data_local.dart';
import 'package:prof/core/navigation/router_generator.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(440, 956),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: GoTransitions.fadeUpwards,
                TargetPlatform.iOS: GoTransitions.cupertino,
                TargetPlatform.macOS: GoTransitions.cupertino,
              },
            ),
          ),
          routerConfig: RouterGenerator.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
