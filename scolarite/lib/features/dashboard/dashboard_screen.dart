import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/dashboard/cubit/bar_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/bar_state.dart';
import 'package:scolarite/features/dashboard/cubit/cards_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/cards_state.dart';
import 'package:scolarite/features/dashboard/cubit/pie_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/pie_state.dart';
import 'package:scolarite/features/dashboard/widgets/bar_chart.dart';
import 'package:scolarite/features/dashboard/widgets/dashboard_card.dart';
import 'package:scolarite/features/dashboard/widgets/pie_chart.dart';
import 'package:scolarite/features/profile/cubit/profile_cubit.dart';
import 'package:scolarite/features/profile/cubit/profile_state.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? _globalError;
  VoidCallback? _retryCallback;

  void _setError(String message, VoidCallback retry) {
    if (_globalError != null) return;
    setState(() {
      _globalError = message;
      _retryCallback = retry;
    });
  }

  void _clearError() {
    if (_globalError == null) return;
    setState(() {
      _globalError = null;
      _retryCallback = null;
    });
  }

  void _retryAll() {
    _clearError();
    context.read<ProfileCubit>().refreshProfile();
    context.read<CardsCubit>().getDashboard();

    context.read<PieCubit>().refresh();
  }

  String getFormattedDate() {
    final now = DateTime.now();
    return DateFormat("EEEE d MMMM yyyy", "fr_FR").format(now);
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().refreshProfile();
    context.read<CardsCubit>().getDashboard();

    context.read<PieCubit>().refresh();

    context.read<BarCubit>().emitLoading();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileErrorState) {
              _setError(state.error, _retryAll);
            } else if (state is ProfileSuccessState) {
              _clearError();
            }
          },
        ),
        BlocListener<CardsCubit, CardsState>(
          listener: (context, state) {
            if (state is CardsErrorState) {
              _setError(state.error, _retryAll);
            } else if (state is CardsSuccessState) {
              _clearError();
              final niveaux = state.cards.niveauxAutorises ?? [];
              final firstNiveau = niveaux.isNotEmpty ? niveaux.first : '';
              if (firstNiveau.isNotEmpty) {
                context.read<BarCubit>().getGraphiqueAbsences(
                  niveau: firstNiveau,
                );
              }
            }
          },
        ),
        BlocListener<BarCubit, BarState>(
          listener: (context, state) {
            if (state is BarErrorState) {
              _setError(state.error, _retryAll);
            } else if (state is BarSuccessState) {
              _clearError();
            }
          },
        ),
        BlocListener<PieCubit, PieState>(
          listener: (context, state) {
            if (state is PieSuccessState) {
              _clearError();
            }
           
          },
        ),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Image.asset(Images.group, fit: BoxFit.fill)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 26.h),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Titre + Date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tableau de Bord", style: AppStyles.blueBBw800),
                          HeightSpace(12),
                          Text(getFormattedDate(), style: AppStyles.grey13w700),
                        ],
                      ),

                      /// Nom + Avatar
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, state) {
                          final isLoading = state is ProfileLoadingState;
                          final profile = state is ProfileSuccessState
                              ? state.profile
                              : null;

                          return Row(
                            children: [
                              // Nom complet
                              isLoading
                                  ? SizedBox(
                                      width: 160.w,
                                      height: 30.h,
                                      child: ShimmerEffect(
                                        baseColor: const Color(0xFFDCE8F7),
                                        highlightColor: const Color(0xFFBFD4F2),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFDCE8F7),
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      profile?.nom_complet ?? "Utilisateur",
                                      style: AppStyles.blueDBw800,
                                    ),

                              WidthSpace(8),

                              // Avatar
                              isLoading
                                  ? ShimmerEffect(
                                      baseColor: const Color(0xFFDCE8F7),
                                      highlightColor: const Color(0xFFBFD4F2),
                                      child: Container(
                                        width: 70.r,
                                        height: 70.r,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFDCE8F7),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 35.r,
                                      backgroundColor: const Color(0xFFDDE6F5),
                                      child: ClipOval(
                                        child: Image.asset(
                                          Images.profile,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  HeightSpace(60),

                  Expanded(
                    child: _globalError != null
                        ? _ErrorState(
                            message: _globalError!,
                            onRetry: _retryCallback!,
                          )
                        : _buildBody(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// DASHBOARD CARDS
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: BlocBuilder<CardsCubit, CardsState>(
              builder: (context, state) {
                if (state is CardsLoadingState) {
                  return ShimmerEffect(
                    baseColor: const Color(0xFFDCE8F7),
                    highlightColor: const Color(0xFFBFD4F2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        3,
                        (_) => Container(
                          width: 250.w,
                          height: 160.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCE8F7),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                if (state is CardsSuccessState) {
                  final data = state.cards;
                  return DashboardCards(
                    valueAbsence: "${data.absencesAujourdhui ?? 0}",
                    subtitleAbsence: data.variationHier ?? "",
                    valueJustificatif: "${data.justificatifsEnAttente ?? 0}",
                    subtitleJustificatif: "À traiter",
                    valueTaux: data.tauxAbsenceGlobal ?? "",
                    subtitleTaux: data.variationMois ?? "",
                  );
                }

                return SizedBox(height: 160.h);
              },
            ),
          ),

          HeightSpace(80),

          /// GRAPHIQUES
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Row(
              children: [
                // Bar chart
                Expanded(
                  flex: 3,
                  child: BlocBuilder<BarCubit, BarState>(
                    builder: (context, state) {
                      if (state is BarErrorState) return const SizedBox();
                      return const AbsenceBarChart();
                    },
                  ),
                ),

                WidthSpace(100),

                // Pie chart
                Expanded(
                  flex: 3,
                  child: AbsencePieChart(
                    sessions: const ["Normale", "Examen"],
                    labelsPerSession: const [
                      ["Justifiée", "Non justifiée"],
                      ["Justifiée", "Non justifiée"],
                    ],
                    valuesPerSession: const [],
                    colorsPerSession: const [
                      [Color(0xff0969BB), Color(0xffBDD7F7)],
                      [Color(0xff0969BB), Color(0xffBDD7F7)],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250.w,
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0969BB).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 42.sp,
              color: Colors.red.withOpacity(0.7),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.grey20w500.copyWith(
                color: const Color(0xFF828282),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6095E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
