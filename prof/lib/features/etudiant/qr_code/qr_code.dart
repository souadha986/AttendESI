import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prof/core/styling/app_colors.dart';
import 'package:prof/core/styling/app_styles.dart';
import 'package:prof/core/utils/snack_bar.dart';
import 'package:prof/core/widgets/spacing.dart';
import 'package:prof/features/etudiant/qr_code/cubit/qr_cubit.dart';
import 'package:prof/features/etudiant/qr_code/cubit/qr_state.dart';

import 'package:qr_flutter/qr_flutter.dart';

class GenerateQrScreen extends StatefulWidget {
  final int matiereId;
  final String moduleName;
  final String groupe; // ✅ String not int
  final String niveau;
  final String specialite;
  final String heureDebut;

  const GenerateQrScreen({
    super.key,
    required this.matiereId,
    required this.moduleName,
    required this.groupe,
    required this.niveau,
    required this.specialite,
    required this.heureDebut,
  });

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  @override
  void initState() {
    super.initState();
    _generate();
  }

  void _generate() {
    context.read<GenerateQrCubit>().generate(
      matiereId: widget.matiereId,
      groupe: int.tryParse(widget.groupe) ?? 0, // ✅ safe parse
      niveau: widget.niveau,
      specialite: widget.specialite,
      heureDebut: widget.heureDebut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        centerTitle: true,
        title: Text("QR Code", style: AppStyles.blueA20w700),
      ),
      backgroundColor: AppColors.whiteColor,
      body: BlocConsumer<GenerateQrCubit, GenerateQrState>(
        listener: (context, state) {
          if (state is GenerateQrError) {
            ShowSnackBar.showAnimatedSnackDialog(
              context: context,
              message: state.error,
              type: AnimatedSnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          if (state is GenerateQrLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF0F6BFA)),
            );
          }

          if (state is GenerateQrSuccess) {
            return RefreshIndicator(
              color: AppColors.blueColorA,
              onRefresh: () async => _generate(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HeightSpace(30),

                    // Info card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6F1FC),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: const Color(0xFFE4EEFA),
                          width: 0.8,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(
                            Icons.book_outlined,
                            "Matière",
                            widget.moduleName,
                          ),
                          HeightSpace(8),
                          _infoRow(
                            Icons.group_outlined,
                            "Groupe",
                            widget.groupe, // ✅ already String
                          ),
                          HeightSpace(8),
                          _infoRow(
                            Icons.school_outlined,
                            "Niveau",
                            "${widget.niveau} - ${widget.specialite}",
                          ),
                          HeightSpace(8),
                          _infoRow(
                            Icons.access_time,
                            "Heure",
                            widget.heureDebut,
                          ),
                        ],
                      ),
                    ),

                    HeightSpace(40),

                    // QR Code
                    Container(
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: QrImageView(
                        data: state.qrData,
                        version: QrVersions.auto,
                        size: 260.w,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: Color(0xFF0F6BFA),
                        ),
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: Color(0xFF123A7A),
                        ),
                      ),
                    ),

                    HeightSpace(30),

                    Text(
                      "Montrez ce QR code aux étudiants",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    HeightSpace(20),

                    // Refresh button
                    TextButton.icon(
                      onPressed: _generate,
                      icon: const Icon(Icons.refresh, color: Color(0xFF0F6BFA)),
                      label: Text(
                        "Regénérer le QR",
                        style: TextStyle(
                          color: const Color(0xFF0F6BFA),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    HeightSpace(30),
                  ],
                ),
              ),
            );
          }

          if (state is GenerateQrError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60.sp,
                      color: Colors.redAccent,
                    ),
                    HeightSpace(16),
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    HeightSpace(20),
                    ElevatedButton.icon(
                      onPressed: _generate,
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        "Réessayer",
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0F6BFA),
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.w,
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: const Color(0xFF0F6BFA)),
        SizedBox(width: 8.w),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF123A7A),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
