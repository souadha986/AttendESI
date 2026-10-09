import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/tableau_board/cubit/chart_cubit.dart';
import 'package:admin/features/tableau_board/cubit/niveau_cubit.dart';
import 'package:admin/features/tableau_board/cubit/niveau_state.dart';
import 'package:admin/features/tableau_board/cubit/specialite_cubit.dart';
import 'package:admin/features/tableau_board/cubit/specialite_state.dart';
import 'package:admin/features/tableau_board/model/tableau_bord_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AbsencesBarChart extends StatefulWidget {
  final List<ChartModel> data;

  const AbsencesBarChart({super.key, required this.data});

  @override
  State<AbsencesBarChart> createState() => _AbsencesBarChartState();
}

class _AbsencesBarChartState extends State<AbsencesBarChart> {
  String? _selectedNiveau;
  String? _selectedSpecialite;

  List<String> get _modules => widget.data.map((e) => e.module ?? '').toList();

  List<double> get _absences =>
      widget.data.map((e) => (e.percentage ?? 0).toDouble()).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 980.w,
      padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Absences par module (7 derniers jours):",
            style: AppStyles.grey15w700.copyWith(fontSize: 18.sp),
          ),
          HeightSpace(20),

          // ── DROPDOWNS NIVEAU + SPECIALITE
          Row(
            children: [
              WidthSpace(40),

              /// NIVEAU
              Text("Niveau:", style: AppStyles.grey15w700),
              WidthSpace(10),

              BlocBuilder<NiveauCubit, NiveauState>(
                builder: (context, state) {
                  if (state is NiveauSuccess) {
                    return _buildDropdown(
                      value: _selectedNiveau,
                      items: state.niveaux,
                      onChanged: (val) {
                        setState(() => _selectedNiveau = val);

                        if (_selectedSpecialite != null) {
                          context.read<ChartCubit>().getChart(
                            niveau: _selectedNiveau!,
                            specialite: _selectedSpecialite!,
                          );
                        }
                      },
                    );
                  }
                  return const SizedBox(width: 120);
                },
              ),

              WidthSpace(40),

              /// SPECIALITE
              Text("spécialité:", style: AppStyles.grey15w700),
              WidthSpace(10),

              BlocBuilder<SpecialiteCubit, SpecialiteState>(
                builder: (context, state) {
                  if (state is SpecialiteSuccess) {
                    return _buildDropdown(
                      value: _selectedSpecialite,
                      items: ['/', ...state.specialites],
                      onChanged: (val) {
                        setState(() => _selectedSpecialite = val);

                        final specialiteToSend = (val == '/' || val == null)
                            ? null
                            : val;

                        context.read<ChartCubit>().getChart(
                          niveau: _selectedNiveau!,
                          specialite: specialiteToSend,
                        );
                      },
                    );
                  }
                  return const SizedBox(width: 120);
                },
              ),
            ],
          ),

          HeightSpace(50),

          /// ── CHART
          SizedBox(
            height: 350.h,
            child: widget.data.isEmpty
                ? Center(
                    child: Text(
                      "Aucune donnée disponible",
                      style: AppStyles.grey20w500.copyWith(
                        color: const Color(0xFF828282),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : BarChart(
                    BarChartData(
                      maxY: 100,
                      minY: 0,
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xffC3C3C3),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xff386BBC),
                            width: 1,
                          ),
                          left: BorderSide(
                            color: const Color(0xff386BBC),
                            width: 1,
                          ),
                        ),
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 11.sp,
                                  color: const Color(0xff090909),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i >= _modules.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  _modules[i].length > 4
                                      ? _modules[i].substring(0, 4)
                                      : _modules[i],
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xff090909),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: List.generate(
                        _modules.length,
                        (i) => BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: _absences[i],
                              color: const Color(0xff3D9EFF),
                              width: 28.w,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4.r),
                                topRight: Radius.circular(4.r),
                              ),
                            ),
                          ],
                        ),
                      ),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBorderRadius: BorderRadius.circular(8.r),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.toInt()}',
                              TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
          ),

          HeightSpace(50),

          Row(
            children: [
              Container(
                width: 28.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: const Color(0xff3D9EFF),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              WidthSpace(10),
              Text("Nombre d'Absence", style: AppStyles.grey15w700),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 0.h),
      decoration: BoxDecoration(
        color: const Color(0xffEFF3F8),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Color(0xffEFF3F8),
          borderRadius: BorderRadius.circular(16.r),
          elevation: 0,
          value: value,
          hint: Text("Select", style: AppStyles.petitBlack),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: AppStyles.petitBlack),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
