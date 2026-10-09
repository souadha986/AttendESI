import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/service_locator.dart';
import 'package:prof/features/etudiant/etudiant.dart';
import 'package:prof/features/home/cubit/absence_cubit.dart';
import 'package:prof/features/home/cubit/profile_cubit.dart';
import 'package:prof/features/home/home.dart';
import 'package:prof/features/planning/cubit/examen_cubit.dart';
import 'package:prof/features/planning/cubit/remplacement_cubit.dart';
import 'package:prof/features/planning/cubit/seance_normale_cubit.dart';
import 'package:prof/features/planning/planning.dart';
import 'package:prof/features/settings/cubit/logout_cubit.dart';
import 'package:prof/features/settings/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<ProfileCubit>()),
          BlocProvider(create: (context) => sl<AbsenceCubit>()),
        ],
        child: const Home(),
      ),

      Etudiant(),
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<SeanceNormaleCubit>()),
          BlocProvider(create: (context) => sl<ExamenCubit>()),
          BlocProvider(create: (context) => sl<RemplacementCubit>()),
        ],
        child: const Planning(),
      ),

      BlocProvider(
        create: (context) => sl<LogoutCubit>(),
        child: const SettingsScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (currentIndex != 0) {
          setState(() {
            currentIndex = 0;
          });
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: IndexedStack(index: currentIndex, children: screens),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.greyColor,
          selectedItemColor: AppColors.blueColorA,
          selectedLabelStyle: AppStyles.blueA15w500,
          unselectedItemColor: AppColors.blueColorA,
          unselectedLabelStyle: AppStyles.blueA15w500.copyWith(fontSize: 13.sp),
          elevation: 1,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 32),
              activeIcon: Icon(Icons.home, size: 33),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined, size: 32),
              activeIcon: Icon(Icons.person_2, size: 33),
              label: 'Etudiants',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 32),
              activeIcon: Icon(Icons.calendar_month, size: 33),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 32),
              activeIcon: Icon(Icons.settings, size: 33),
              label: 'Paramètres',
            ),
          ],
        ),
      ),
    );
  }
}
