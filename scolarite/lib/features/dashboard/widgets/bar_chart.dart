import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/dashboard/cubit/bar_cubit.dart';
import 'package:scolarite/features/dashboard/cubit/bar_state.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class AbsenceBarChart extends StatefulWidget {
  final List<String>? levels;
  final String title;

  const AbsenceBarChart({
    super.key,
    this.levels,
    this.title = "ABSENCE PAR MODULE",
  });

  @override
  State<AbsenceBarChart> createState() => _AbsenceBarChartState();
}

class _AbsenceBarChartState extends State<AbsenceBarChart> {
  int selectedIndex = 0;
  List<String> modules = [];
  List<double> values = [];

  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BarCubit, BarState>(
      builder: (context, state) {
        // SHIMMER LOADING
        if (state is BarLoadingState) {
          return ShimmerEffect(
            baseColor: Color(0xFFDCE8F7),
            highlightColor: Color(0xFFBFD4F2),
            child: Container(
              height: 500.h,
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: const Color(0xff386BBC)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 200.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Color(0xFFDCE8F7),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          color: Color(0xFFDCE8F7),
                        ),
                        width: 70.w,
                        height: 40.h,
                      ),
                    ],
                  ),
                  HeightSpace(30),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: const Color(0xff386BBC),
                          width: 2.w,
                        ),
                        bottom: BorderSide(
                          color: const Color(0xff386BBC),
                          width: 2.w,
                        ),
                      ),
                    ),
                    height: 300.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(5, (index) {
                        final height = (index + 1) * 40.0;
                        return Container(
                          width: 30.w,
                          height: height.h,
                          decoration: BoxDecoration(
                            color: Color(0xFF6095E8).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4.r),
                            border: Border(
                              bottom: BorderSide(
                                color: const Color(0xff386BBC),
                                width: 2.w,
                              ),
                              left: BorderSide(
                                color: const Color(0xff386BBC),
                                width: 2.w,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  HeightSpace(20),
                  Row(
                    children: [
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF6095E8).withOpacity(0.5),
                        ),
                      ),
                      WidthSpace(10),
                      Container(
                        width: 150.w,
                        height: 30.h,
                        color: Color(0xFFDCE8F7),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        // SUCCESS STATE
        if (state is BarSuccessState) {
          final barModel = state.barModel;
          modules =
              barModel.graphiqueAbsences
                  ?.map((e) => e.matiere ?? "")
                  .toList() ??
              [];
          values =
              barModel.graphiqueAbsences?.map((e) {
                final p = e.pourcentage;
                if (p == null) return 0.0;

                return double.tryParse(p.replaceAll('%', '')) ?? 0.0;
              }).toList() ??
              [];
          // Si vide, ajouter une barre placeholder
          if (modules.isEmpty) modules = [""];
          if (values.isEmpty) values = [0.0];
          [];
        }
        final maxY = 100.0;
        /////////////////////////////////////////////////////////////////////////////
        return Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xff386BBC)),
          ),
          child: Column(
            children: [
              /// HEADER + DROPDOWN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.title, style: AppStyles.grey13w700),
                  DropdownButton<int>(
                    borderRadius: BorderRadius.circular(10.r),
                    dropdownColor: Color(0xffF0F7FE),
                    value: context.watch<BarCubit>().selectedNiveauIndex,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<BarCubit>().setSelectedNiveau(value);
                      }
                    },
                    underline: const SizedBox(),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18.sp,
                      color: const Color(0xff2F7EF8),
                    ),
                    items: List.generate(
                      context.watch<BarCubit>().niveauxDisponibles.length,
                      (index) => DropdownMenuItem(
                        value: index,
                        child: Text(
                          context.watch<BarCubit>().niveauxDisponibles[index],
                          style: AppStyles.black16wBold.copyWith(
                            color: Color(0xff2F7EF8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              HeightSpace(20),

              /// BAR CHART
              SizedBox(
                height: 300.h,
                child: BarChart(
                  BarChartData(
                    maxY: maxY,
                    alignment: BarChartAlignment.spaceAround,
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: (maxY / 5),
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey.withOpacity(0.2)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(
                          color: const Color(0xff386BBC),
                          width: 2.w,
                        ),
                        bottom: BorderSide(
                          color: const Color(0xff386BBC),
                          width: 2.w,
                        ),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: (maxY / 10),
                          getTitlesWidget: (value, _) => Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, _) {
                            if (value.toInt() >= modules.length) {
                              return const SizedBox();
                            }
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                modules[value.toInt()].length > 4
                                    ? modules[value.toInt()].substring(0, 4)
                                    : modules[value.toInt()],
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    barGroups: List.generate(
                      values.length,
                      (index) => BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: values[index],
                            width: 20.w,
                            color: const Color(0xff6095E8),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              HeightSpace(20),

              /// LEGEND
              Padding(
                padding: EdgeInsets.all(15.sp),
                child: Row(
                  children: [
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff6095E8),
                      ),
                    ),
                    WidthSpace(6),
                    Text(
                      "Nombre d'Absence",
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
