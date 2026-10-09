import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/dashboard/cubit/pie_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/pie_state.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class AbsencePieChart extends StatefulWidget {
  final List<String> sessions;
  final List<List<String>> labelsPerSession;
  final List<List<double>> valuesPerSession;
  final List<List<Color>> colorsPerSession;

  const AbsencePieChart({
    super.key,
    required this.sessions,
    required this.labelsPerSession,
    required this.valuesPerSession,
    required this.colorsPerSession,
  });

  @override
  State<AbsencePieChart> createState() => _AbsencePieChartState();
}

class _AbsencePieChartState extends State<AbsencePieChart> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PieCubit, PieState>(
      builder: (context, state) {
        if (state is PieLoadingState) {
          return const PieChartShimmer();
        }
        if (state is PieSuccessState) {
          final cubit = context.read<PieCubit>();
          final selectedIndex = cubit.selectedIndex;

          // Safety check
          if (selectedIndex >= 2) {
            return const Center(child: Text('Invalid session'));
          }

          final pieModel = selectedIndex == 0 ? state.normale : state.examen;
          if (pieModel?.graphiqueJustification == null) {
            return const PieChartShimmer(isSmall: true);
          }

          final data = pieModel!.graphiqueJustification!;

          final nonJustifie = data.nonJustifie?.toDouble() ?? 0;
          final justifie = data.valide?.toDouble() ?? 0;
          final values = [justifie, nonJustifie];

          final labels = ['Justifiée', 'Non justifiée'];

          final colors = [
            const Color(0xff0969BB), // Justifiée
            const Color(0xffBDD7F7), // Non justifiée
          ];

          // Filter zero values
          final validIndices = values
              .asMap()
              .entries
              .where((e) => e.value > 0)
              .map((e) => e.key)
              .toList();
          final validValues = validIndices.map((i) => values[i]).toList();
          final validLabels = validIndices.map((i) => labels[i]).toList();
          final validColors = validIndices.map((i) => colors[i]).toList();

          if (validValues.isEmpty) {
            return Container(
              height: 500.h,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xff386BBC)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("ABSENCE PAR TYPE", style: AppStyles.grey13w700),
                      DropdownButton<int>(
                        borderRadius: BorderRadius.circular(10.r),
                        dropdownColor: const Color(0xffF0F7FE),
                        value: context.read<PieCubit>().selectedIndex,
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          size: 18.sp,
                          color: const Color(0xff2F7EF8),
                        ),
                        items: List.generate(widget.sessions.length, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text(
                              widget.sessions[index],
                              style: AppStyles.black16wBold.copyWith(
                                color: const Color(0xff2F7EF8),
                              ),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) {
                            context.read<PieCubit>().changeSession(value);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 120.h),
                  Icon(
                    Icons.error_outline_rounded,
                    size: 42.sp,
                    color: const Color(0xffBDD7F7),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Aucune absence enregistrée",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF828282),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            );
          }

          final total = justifie + nonJustifie;

          return Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xff386BBC)),
            ),
            child: Column(
              children: [
                /// HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ABSENCE PAR TYPE", style: AppStyles.grey13w700),
                    DropdownButton<int>(
                      borderRadius: BorderRadius.circular(10.r),
                      dropdownColor: Color(0xffF0F7FE),
                      value: selectedIndex,
                      underline: const SizedBox(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 18.sp,
                        color: const Color(0xff2F7EF8),
                      ),
                      items: List.generate(widget.sessions.length, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(
                            widget.sessions[index],
                            style: AppStyles.black16wBold.copyWith(
                              color: const Color(0xff2F7EF8),
                            ),
                          ),
                        );
                      }),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<PieCubit>().changeSession(value);
                        }
                      },
                    ),
                  ],
                ),

                HeightSpace(40),

                /// PIE
                SizedBox(
                  height: 200.h,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sectionsSpace: 0,
                      centerSpaceRadius: 0,
                      sections: List.generate(validValues.length, (index) {
                        final percent = total == 0
                            ? 0
                            : (validValues[index] / total) * 100;
                        return PieChartSectionData(
                          value: validValues[index],
                          color: validColors[index],
                          radius: 120.w,
                          title: "${percent.toStringAsFixed(0)}%",
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                HeightSpace(100),

                /// LEGEND
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 50,
                  children: List.generate(validLabels.length, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: validColors[index],
                            shape: BoxShape.circle,
                          ),
                        ),
                        WidthSpace(6),
                        Text(
                          validLabels[index],
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          );
        }

        if (state is PieErrorState) {
          return Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xff386BBC)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: 42.sp,
                  color: Colors.red.withOpacity(0.7),
                ),
                SizedBox(height: 16.h),
                Text(
                  state.error,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: const Color(0xFF828282),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton.icon(
                  onPressed: () => context.read<PieCubit>().refresh(),
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
          );
        }
        return const PieChartShimmer();
      },
    );
  }
}

class PieChartShimmer extends StatelessWidget {
  final bool isSmall;

  const PieChartShimmer({super.key, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      baseColor: const Color(0xFFDCE8F7),
      highlightColor: const Color(0xFFBFD4F2),
      child: Container(
        height: 470.h,
        width: double.infinity,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xff386BBC)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: isSmall ? 150.w : 190.w,
                  height: isSmall ? 20.h : 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                Container(
                  width: isSmall ? 60.w : 70.w,
                  height: isSmall ? 30.h : 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),

            HeightSpace(30),

            /// PIE
            Center(
              child: Container(
                width: 300.w,
                height: 300.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            HeightSpace(20),

            /// LEGEND
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Row(
                  children: [
                    Container(
                      width: isSmall ? 15.w : 30.w,
                      height: isSmall ? 15.h : 30.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    WidthSpace(8),
                    Container(
                      width: isSmall ? 80.w : 100.w,
                      height: isSmall ? 12.h : 30.h,
                      color: Colors.white,
                    ),
                    WidthSpace(20),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
