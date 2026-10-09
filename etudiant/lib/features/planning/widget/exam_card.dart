import 'package:etudiant/features/planning/models/examen_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/widgets/spacing.dart';

class ExamenCard extends StatelessWidget {
  final String date;
  final List<Activite> sessions;

  const ExamenCard({super.key, required this.date, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: Container(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(bottom: 26.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE6F1FC),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: const Color(0xFFE4EEFA), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0091FF), Color(0xFF0072FF)],
                ),
              ),
              child: Text(
                date,
                style: AppStyles.white15w700.copyWith(fontSize: 20.sp),
              ),
            ),
            Column(
              children: sessions.map((session) {
                final isLast = sessions.indexOf(session) == sessions.length - 1;
                return Column(
                  children: [
                    _buildSessionDetail(session),
                    if (!isLast)
                      const Divider(
                        color: Colors.white,
                        thickness: 2,
                        height: 1,
                      ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDetail(Activite session) {
    final String startTime = DateFormat('HH:mm').format(session.heureDebut);
    final String endTime = DateFormat('HH:mm').format(session.heureFin);

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(session.nomMatiere, style: AppStyles.black15w600),
          HeightSpace(6),
          Text(
            "Jour: ${session.jourNom}",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          HeightSpace(12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18.sp,
                color: const Color(0xFF123A7A),
              ),
              SizedBox(width: 6.w),
              Text(
                "$startTime - $endTime",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF123A7A),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 20.w),
              Icon(
                Icons.location_on_outlined,
                size: 18.sp,
                color: const Color(0xFF123A7A),
              ),
              SizedBox(width: 4.w),
              Text(
                session.salle,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF123A7A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
