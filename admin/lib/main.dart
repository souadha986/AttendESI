import 'package:admin/core/navigation/router_generator.dart';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/utils/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://pyorzbawlhuoexnneino.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB5b3J6YmF3bGh1b2V4bm5laW5vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE2MjMwMjgsImV4cCI6MjA4NzE5OTAyOH0.xpxExEXzI2s4C11HS7VEd0xDf9bh-rvZ7PCXYRh4gqs',
  );
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
      designSize: Size(1440, 960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.whiteColor,
            textSelectionTheme: TextSelectionThemeData(
              selectionColor: Color(
                0xFF06A1F1,
              ).withOpacity(0.3), // fond sélection
              selectionHandleColor: Color(0xFF06A1F1), // curseur (poignées)
              cursorColor: Color(0xFF0F6AFA), // curseur clignotant
            ),
          ),
          routerConfig: RouterGenerator.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
