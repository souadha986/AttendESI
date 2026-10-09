import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/profile/cubit/profile_cubit.dart';
import 'package:scolarite/features/profile/cubit/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _globalError;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileErrorState) {
      _globalError = state.error;
    }
  }

  void _setError(String message) {
    if (_globalError != null) return;
    setState(() => _globalError = message);
  }

  void _clearError() {
    if (_globalError == null) return;
    setState(() => _globalError = null);
  }

  void _retry() {
    _clearError();
    context.read<ProfileCubit>().refreshProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          _setError(state.error);
        } else if (state is ProfileSuccessState) {
          _clearError();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: Image.asset(Images.group, fit: BoxFit.fill)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 26.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profil", style: AppStyles.blueBBw800),
                  HeightSpace(150),
                  Expanded(
                    child: _globalError != null
                        ? _ErrorState(message: _globalError!, onRetry: _retry)
                        : _buildBody(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff6095E8)),
          );
        }

        if (state is ProfileSuccessState) {
          final profile = state.profile;
          return Center(
            child: Container(
              width: 480.w,
              height: 590.h,
              decoration: BoxDecoration(
                color: const Color(0xffDCECFF),
                border: Border.all(color: const Color(0xff1351FE)),
                borderRadius: BorderRadius.circular(26.r),
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
                        child: Image.asset(Images.profil2, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  HeightSpace(20),

                  /// NOM
                  Text(
                    profile.nom_complet ?? '',
                    style: AppStyles.blueDBw800.copyWith(fontSize: 21.sp),
                  ),

                  HeightSpace(40),

                  /// ROLE
                  Container(
                    height: 50.h,
                    width: 400.w,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff123A7A)),
                      borderRadius: BorderRadius.circular(17.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      profile.role ?? '',
                      style: AppStyles.black45Bold,
                    ),
                  ),

                  HeightSpace(40),

                  /// ETABLISSEMENT
                  Text(
                    profile.etablissement ??
                        "École Superieure d'Informatique – ESI",
                    style: AppStyles.black45Bold,
                  ),

                  HeightSpace(40),

                  /// STATUT
                  Container(
                    height: 40.h,
                    width: 100.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: const Color(0xff95CD9B),
                    ),
                    child: Center(
                      child: Text(
                        profile.statut ?? '',
                        style: AppStyles.black45Bold.copyWith(
                          color: const Color(0xff075C0E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 250.w,
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0969BB).withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 42.sp,
              color: Colors.red.withOpacity(0.7),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppStyles.grey20w500.copyWith(
                color: const Color(0xFF828282),
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6095E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
