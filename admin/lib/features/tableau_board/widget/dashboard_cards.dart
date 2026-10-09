import 'package:admin/core/assets/images.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/tableau_board/model/tableau_bord_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget pour une seule carte du dashboard
class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String image;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220.w,
      height: 180.h,
      padding: EdgeInsets.only(left: 14.w, top: 14.h, right: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 15.sp,
                      color: Color(0xff4C4C4D),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Image.asset(
                image,
                width: 38.w,
                height: 40.h,
                fit: BoxFit.contain,
              ),
            ],
          ),
          HeightSpace(10),
          Text(
            value,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 18.sp,
                color: Color(0xff454545),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          HeightSpace(10),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 13.sp,
                color: Color(0xff828282),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher les 4 cartes
class DashboardCards extends StatelessWidget {
  final Stats stats;

  const DashboardCards({super.key, required this.stats});

  String get _trendSubtitle {
    final isUp = stats.absencesTrend?.isUp ?? false;
    final percentage = stats.absencesTrend?.percentage ?? '';
    return '${isUp ? '↑' : '↓'} $percentage vs hier';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DashboardCard(
          title: "Absences aujourd'hui",
          value: (stats.absencesToday ?? 0).toString(),
          subtitle: _trendSubtitle,
          image: Images.icon1,
        ),

        DashboardCard(
          title: "Taux d'absence globale",
          value: stats.globalRate ?? '',
          subtitle: "",
          image: Images.icon2,
        ),

        DashboardCard(
          title: "Proches exclusion \n ",
          value: (stats.procheExclusion ?? 0).toString(),
          subtitle: "",
          image: Images.icon3,
        ),

        DashboardCard(
          title: "Étudiants à maladie chronique",
          value: (stats.chronicDiseases ?? 0).toString(),
          subtitle: "",
          image: Images.malade,
        ),
      ],
    );
  }
}
