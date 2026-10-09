import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/service_locator.dart';
import 'package:etudiant/features/home/cubit/absence_cubit.dart';
import 'package:etudiant/features/home/cubit/alerts_cubit.dart';
import 'package:etudiant/features/home/cubit/profile_cubit.dart';
import 'package:etudiant/features/home/home.dart';
import 'package:etudiant/features/justificatifs/cubit/justificatifs_cubit.dart';
import 'package:etudiant/features/justificatifs/justificatifs.dart';
import 'package:etudiant/features/planning/cubit/examen_cubit.dart';
import 'package:etudiant/features/planning/cubit/remplacement_cubit.dart';
import 'package:etudiant/features/planning/cubit/seance_normal_cubit.dart';
import 'package:etudiant/features/planning/planning.dart';
import 'package:etudiant/features/qr_code/qr_code.dart';
import 'package:etudiant/features/qr_code/qr_cubit/qr_cubit.dart';
import 'package:etudiant/features/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          BlocProvider(create: (context) => sl<AlertCubit>()),
        ],
        child: const Home(),
      ),
      BlocProvider(
        create: (context) => sl<JustificatifsCubit>(),
        child: const Justificatifs(),
      ),
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<SeanceNormaleCubit>()),
          BlocProvider(create: (context) => sl<ExamenCubit>()),
          BlocProvider(create: (context) => sl<RemplacementCubit>()),
        ],
        child: const Planning(),
      ),
      BlocProvider(
        create: (context) => sl<QrcodeCubit>(),
        child: const QrcodeScreen(),
      ),
      const SettingsScreen(),
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
              icon: Icon(Icons.description_outlined, size: 32),
              activeIcon: Icon(Icons.description, size: 33),
              label: 'Justificatifs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined, size: 32),
              activeIcon: Icon(Icons.calendar_month, size: 33),
              label: 'Planning',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_outlined, size: 32), // ✅
              activeIcon: Icon(Icons.qr_code, size: 33), // ✅
              label: 'QR code', // ✅
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
