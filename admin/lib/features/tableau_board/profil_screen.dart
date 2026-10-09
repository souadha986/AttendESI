import 'package:admin/core/assets/images.dart';
import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/styling/app_styles.dart';
import 'package:admin/core/widgets/spacing.dart';
import 'package:admin/features/tableau_board/cubit/profile_cubit.dart';
import 'package:admin/features/tableau_board/cubit/profile_state.dart';
import 'package:admin/features/tableau_board/tableau_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class ProfilScreen extends StatefulWidget {
  final String adminName;
  final VoidCallback? onBack;
  const ProfilScreen({super.key, required this.adminName, this.onBack});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          toolbarHeight: 125.h,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flèche retour
                InkWell(
                  onTap: () => widget.onBack?.call(),
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0969BB).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: const Color(0xFF0969BB),
                      size: 18.sp,
                    ),
                  ),
                ),
                WidthSpace(15),
                // Titre et date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Profil",
                      style: AppStyles.white24w700.copyWith(
                        color: const Color(0xFF0969BB),
                        fontSize: 23.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    HeightSpace(4),
                    Text(
                      DateFormat(
                        'EEEE d MMMM yyyy',
                        'fr_FR',
                      ).format(DateTime.now()),
                      style: AppStyles.white20w700.copyWith(
                        color: const Color(0xFF828282),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
          child: Column(
            children: [
              HeightSpace(100),
              Center(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    /// LOADING
                    /// LOADING
                    if (state is ProfileLoadingState) {
                      return ShimmerEffect(
                        baseColor: const Color(0xFFDCE8F7),
                        highlightColor: const Color(0xFFBFD4F2),
                        child: Container(
                          width: 480.w,
                          height: 590.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent, // ← ce blanc bloque tout
                            borderRadius: BorderRadius.circular(25.r),
                            border: Border.all(color: Color(0xFFDCE8F7)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              HeightSpace(70),

                              /// AVATAR
                              CircleAvatar(
                                radius: 70.r,
                                backgroundColor: const Color(0xFFDCE8F7),
                              ),

                              HeightSpace(30),

                              /// NOM
                              Container(
                                width: 200.w,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE8F7),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),

                              HeightSpace(40),

                              /// ROLE
                              Container(
                                height: 30.h,
                                width: 400.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE8F7),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),

                              HeightSpace(10),

                              /// ETABLISSEMENT
                              Container(
                                width: 320.w,
                                height: 30.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE8F7),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),

                              HeightSpace(60),

                              /// STATUT
                              Container(
                                height: 60.h,
                                width: 200.w,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCE8F7),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    /// ERROR
                    if (state is ProfileErrorState) {
                      return ErrorS(
                        message: state.error,
                        onRetry: () {
                          context.read<ProfileCubit>().refreshProfile();
                        },
                      );
                    }

                    /// SUCCESS
                    final String name = state is ProfileSuccessState
                        ? state.profile.nomComplet ?? "Admin"
                        : "Admin";

                    return Container(
                      width: 480.w,
                      height: 590.h,
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          HeightSpace(70),

                          /// IMAGE
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 2,
                                  offset: const Offset(1, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 70.r,
                              backgroundColor: const Color(0xFFEFF3F8),
                              child: ClipOval(
                                child: Image.asset(
                                  Images.profile2,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),

                          HeightSpace(20),

                          /// NOM
                          Text(name, style: AppStyles.blueDBw800),

                          HeightSpace(40),

                          /// ROLE
                          Container(
                            height: 50.h,
                            width: 400.w,
                            alignment: Alignment.center,
                            child: Text("Admin", style: AppStyles.black45Bold),
                          ),

                          HeightSpace(10),

                          /// ETABLISSEMENT
                          Text(
                            "École Superieure d'Informatique – ESI",
                            style: AppStyles.black45Bold,
                          ),

                          HeightSpace(60),

                          /// STATUT
                          Container(
                            height: 60.h,
                            width: 200.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0F6AFA), Color(0xFF06A1F1)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "Actif",
                                style: AppStyles.white20w700.copyWith(
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              HeightSpace(100),
            ],
          ),
        ),
      ),
    );
  }
}
