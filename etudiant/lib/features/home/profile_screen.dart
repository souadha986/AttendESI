import 'package:etudiant/core/assets/images.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  final String nom;
  final String prenom;
  final String willayaNaiss;
  final String dateNaissance;
  final String situation;
  final int groupe;
  final String specialite;

  const ProfileScreen({
    super.key,
    required this.nom,
    required this.prenom,

    required this.willayaNaiss,
    required this.dateNaissance,
    required this.situation,
    required this.groupe,
    required this.specialite,
  });

  String _formatDate(String raw) {
    try {
      final dt = DateTime.parse(raw);
      return DateFormat("dd-MM-yyyy").format(dt);
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: AppStyles.blueA20w700),
        centerTitle: true,
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    HeightSpace(20),

                    CircleAvatar(
                      radius: 90.r,
                      backgroundColor: const Color(0xFFE4EEFA),

                      child: Image.asset(Images.profile),
                    ),

                    HeightSpace(16),

                    Text(
                      "$prenom $nom",
                      style: AppStyles.black15w700.copyWith(
                        fontSize: 18.sp,
                        color: const Color(0xFF123A7A),
                      ),
                    ),

                    HeightSpace(24),

                    _InfoCard(
                      child: Center(
                        child: Text(
                          "Ecole superieur en Informatique 08 mai 1945\n-${willayaNaiss.toUpperCase()}-",
                          textAlign: TextAlign.center,
                          style: AppStyles.blueA20w700.copyWith(
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),

                    HeightSpace(19),

                    _InfoCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 37.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Date de naissance",
                              style: AppStyles.blue14w700.copyWith(
                                color: Color(0xFF1F3352),
                              ),
                            ),
                            HeightSpace(6),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16.sp,
                                  color: Colors.grey[600],
                                ),
                                WidthSpace(6),
                                Text(
                                  _formatDate(dateNaissance),
                                  style: AppStyles.grey14w700,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    HeightSpace(21),

                    _InfoCard(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 37.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Place de naissance",
                              style: AppStyles.blue14w700.copyWith(
                                color: Color(0xFF1F3352),
                              ),
                            ),
                            HeightSpace(6),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_city_outlined,
                                  size: 16.sp,
                                  color: Colors.grey[600],
                                ),
                                WidthSpace(6),
                                Text(willayaNaiss, style: AppStyles.grey14w700),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    HeightSpace(21),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F7FC),
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 37.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InfoChip(label: "Niveau", value: situation),

                            _InfoChip(label: "Groupe", value: "$groupe"),

                            _InfoChip(label: "Spécialité", value: specialite),
                          ],
                        ),
                      ),
                    ),

                    HeightSpace(30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F7FC),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$label: ",
            style: AppStyles.blue14w700.copyWith(color: Color(0xFF1F3352)),
          ),
          TextSpan(text: value, style: AppStyles.grey14w700),
        ],
      ),
    );
  }
}
