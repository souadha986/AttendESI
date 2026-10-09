import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/core/assets/images.dart';


class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String image;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      height: 160.h,
      padding: EdgeInsets.only(left: 14.w, top: 14.h, right: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xffEFF3F8),
        border: Border.all(color: const Color(0xff75A9FF)),
        borderRadius: BorderRadius.circular(15.r),
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
            children: [
              Flexible(
                child: Text(
                  title,
                  style: AppStyles.black16wBold,
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
          HeightSpace(8),
          Text(value, style: AppStyles.black16wBold.copyWith(fontSize: 16.sp)),
          HeightSpace(8),
          Text(subtitle, style: AppStyles.grey13Bold),
        ],
      ),
    );
  }
}

/// Widget pour afficher les 3 cartes
class DashboardCards extends StatelessWidget {
  final String valueAbsence;
  final String subtitleAbsence;
  final String valueJustificatif;
  final String subtitleJustificatif;
  final String valueTaux;
  final String subtitleTaux;

  const DashboardCards({
    super.key,
    required this.valueAbsence,
    required this.subtitleAbsence,
    required this.valueJustificatif,
    required this.subtitleJustificatif,
    required this.valueTaux,
    required this.subtitleTaux,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DashboardCard(
          title: "Absences   aujourd'hui",
          value: valueAbsence,
          subtitle: subtitleAbsence,
          image: Images.bleu,
        ),
        DashboardCard(
          title: "Justificatifs en attente",
          value: valueJustificatif,
          subtitle: subtitleJustificatif,
          image: Images.vert,
        ),
        DashboardCard(
          title: "Taux d'absence globale",
          value: valueTaux,
          subtitle: subtitleTaux,
          image: Images.jaune,
        ),
      ],
    );
  }
}
