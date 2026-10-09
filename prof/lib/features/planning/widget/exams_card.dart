import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/features/planning/models/examen_model.dart';

class ExamenCard extends StatelessWidget {
  final String day;
  final String date;
  final List<ActiviteExamen> sessions;

  const ExamenCard({
    super.key,
    required this.day,
    required this.date,
    required this.sessions,
  });

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day,
                    style: AppStyles.white15w700.copyWith(fontSize: 20.sp),
                  ),
                  Text(
                    date,
                    style: AppStyles.white15w700.copyWith(fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            Column(
              children: sessions.map((session) {
                final isLast = sessions.indexOf(session) == sessions.length - 1;
                return Column(
                  children: [
                    _buildExamenSessionDetail(session),
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

  String _formatTime(dynamic raw) {
    if (raw == null) return "--:--";
    final str = raw.toString().trim();
    if (str.isEmpty || str == 'null') return "--:--";

    // Already "HH:mm" or "HH:mm:ss"
    final simpleMatch = RegExp(r'^(\d{1,2}:\d{2})').firstMatch(str);
    if (simpleMatch != null) return simpleMatch.group(1)!;

    // DateTime string like "2024-01-01 08:30:00.000"
    final dtMatch = RegExp(
      r'\d{4}-\d{2}-\d{2}[T ](\d{2}:\d{2})',
    ).firstMatch(str);
    if (dtMatch != null) return dtMatch.group(1)!;

    return "--:--";
  }

  Widget _buildExamenSessionDetail(ActiviteExamen session) {
    final String heureDebut = _formatTime(session.heureDebut);
    final String heureFin = _formatTime(session.heureFin);
    final String specialite = session.specialite ?? "N/A";
    final String promo = session.promo ?? "N/A";
    final String matiere = session.matiere ?? "N/A";
    final String salle = session.salle ?? "N/A";
    final String role = session.role ?? "N/A";
    final String responsables = (session.tousResponsables ?? []).join(', ');
    final String surveillants = (session.tousSurveillants ?? []).join(', ');

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18.sp,
                color: const Color(0xFF123A7A),
              ),
              SizedBox(width: 5.w),
              Text(
                "$heureDebut - $heureFin",
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color(0xFF123A7A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildInfoRow("Promo:", promo),
          _buildInfoRow("Spécialité:", specialite),
          _buildInfoRow("Matière:", matiere),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Salle / Amphi: ",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.location_on,
                size: 16.sp,
                color: const Color(0xFF123A7A),
              ),
              Expanded(
                child: Text(
                  salle,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF123A7A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _buildInfoRow("Role:", role),
          _buildInfoRow(
            "Responsable:",
            responsables.isEmpty ? "N/A" : responsables,
          ),
          _buildInfoRow(
            "Surveillances:",
            surveillants.isEmpty ? "N/A" : surveillants,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          children: [
            TextSpan(
              text: "$label ",
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
