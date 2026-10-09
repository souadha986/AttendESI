import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_transitions/go_transitions.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:scolarite/core/navigation/router_generator.dart';
import 'package:scolarite/core/styling/app_colors.dart';
import 'package:scolarite/core/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  await initializeDateFormatting('fr_FR', null);
  Intl.defaultLocale = 'fr_FR';
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1440, 1000),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: GoTransitions.fadeUpwards,
                TargetPlatform.iOS: GoTransitions.cupertino,
                TargetPlatform.macOS: GoTransitions.cupertino,
              },
            ),
            scaffoldBackgroundColor: AppColors.whiteColor,
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color(0xFF1351FE),
              selectionColor: Color(0xFF1351FE).withOpacity(0.3),
              selectionHandleColor: Color(0xFF1351FE),
            ),
          ),
          routerConfig: RouterGenerator.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}