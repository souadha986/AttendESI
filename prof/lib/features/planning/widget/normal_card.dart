import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/planning/models/seance_normale_model.dart';

class NormalCard extends StatelessWidget {
  final String day;
  final List<Seance> sessions;
  const NormalCard({super.key, required this.day, required this.sessions});

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
                day,
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

  Widget _buildSessionDetail(Seance session) {
    final String startTime = session.heureDebut != null
        ? DateFormat('HH:mm').format(session.heureDebut!)
        : "--:--";
    final String endTime = session.heureFin != null
        ? DateFormat('HH:mm').format(session.heureFin!)
        : "--:--";

    final String groups = session.groupe.isNotEmpty
        ? session.groupe.join(', ')
        : "N/A";

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(session.nomMatiere, style: AppStyles.black15w600),
          HeightSpace(6),
          Text(
            "Niveau: ${session.situation}    Type: ${session.typeSeance}",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          HeightSpace(3),
          Text(
            "Spécialité: ${session.specialite}    Groupe: $groups",
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
