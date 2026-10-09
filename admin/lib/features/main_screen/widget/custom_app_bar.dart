import 'package:admin/core/assets/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? userName;
  final String? avatarUrl;
  final VoidCallback? onProfileTap;
  final bool isLoading;
  final bool showProfileSection;
  const CustomAppBar({
    super.key,
    required this.title,
    this.userName,
    this.avatarUrl,
    this.onProfileTap,
    this.isLoading = false,
    required this.showProfileSection,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 126.h,
      backgroundColor: AppColors.whiteColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20.w,
      centerTitle: false,
      shape: const Border(
        bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
      ),

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "   $title",
            style: AppStyles.white24w700.copyWith(
              color: const Color(0xFF0969BB),
              fontSize: 23.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          HeightSpace(8),
          Text(
            _getFormattedDate(),
            style: AppStyles.white20w700.copyWith(
              color: Color(0xFF828282),
              fontSize: 13.sp,
            ),
          ),
        ],
      ),

      actions: showProfileSection
          ? [
              Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: InkWell(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: onProfileTap,
                  child: Row(
                    children: [
                      isLoading
                          ? ShimmerEffect(
                              baseColor: const Color(0xFFDCE8F7),
                              highlightColor: const Color(0xFFBFD4F2),
                              child: Container(
                                width: 120.w,
                                height: 20.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE8F7),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                            )
                          : Text(
                              userName ?? "Admin",
                              style: AppStyles.blueDBw800,
                            ),

                      SizedBox(width: 10.w),

                      isLoading
                          ? ShimmerEffect(
                              baseColor: const Color(0xFFDCE8F7),
                              highlightColor: const Color(0xFFBFD4F2),
                              child: Container(
                                width: 70.r,
                                height: 70.r,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFDCE8F7),
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
                  ),
                ),
              ),
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(126.h);
}

String _getFormattedDate() {
  final now = DateTime.now();
  return DateFormat("    EEEE d MMMM yyyy", "fr_FR").format(now);
}
