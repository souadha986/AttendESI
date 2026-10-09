import 'dart:convert';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/utils/snack_bar.dart';
import 'package:etudiant/features/qr_code/qr_cubit/qr_cubit.dart';
import 'package:etudiant/features/qr_code/qr_cubit/qr_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrcodeScreen extends StatefulWidget {
  const QrcodeScreen({super.key});

  @override
  State<QrcodeScreen> createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends State<QrcodeScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool hasScanned = false;
  bool cameraPermissionGranted = false;
  double _zoomFactor = 0.0; // ✅

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        cameraPermissionGranted = status.isGranted;
      });
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture, BuildContext context) {
    if (hasScanned) return;
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue == null) return;

    debugPrint("QR RAW VALUE: ${barcode!.rawValue}");

    try {
      String raw = barcode.rawValue!;

      // ✅ Fix unquoted keys only
      String fixedJson = raw.replaceAllMapped(
        RegExp(r'(\w+):'),
        (m) => '"${m[1]}":',
      );
      // ✅ Fix unquoted string values only (not numbers)
      fixedJson = fixedJson.replaceAllMapped(
        RegExp(r':\s*([^",\{\}\[\]0-9][^,\{\}\[\]]*)'),
        (m) => ': "${m[1]!.trim()}"',
      );

      debugPrint("FIXED JSON: $fixedJson");

      final data = jsonDecode(fixedJson);

      // ✅ handle both String and int
      final seanceId = int.tryParse(data['seanceId'].toString());
      if (seanceId == null) throw Exception("seanceId invalide");

      setState(() => hasScanned = true);
      context.read<QrcodeCubit>().submitScan(seanceId);
    } catch (e) {
      debugPrint("QR PARSE ERROR: $e");
      ShowSnackBar.showAnimatedSnackDialog(
        context: context,
        message: "QR code invalide",
        type: AnimatedSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<QrcodeCubit, QrcodeState>(
      listener: (context, state) {
        if (state is QrcodeSuccess) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.message,
            type: AnimatedSnackBarType.success,
          );
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => hasScanned = false);
          });
        } else if (state is QrcodeError) {
          ShowSnackBar.showAnimatedSnackDialog(
            context: context,
            message: state.error,
            type: AnimatedSnackBarType.error,
          );
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) setState(() => hasScanned = false);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Scanner QR", style: AppStyles.blueA20w700),
          centerTitle: true,
          backgroundColor: AppColors.greyColor,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.black,
        body: cameraPermissionGranted
            ? _buildScanner(context)
            : _buildPermissionDenied(),
      ),
    );
  }

  Widget _buildScanner(BuildContext context) {
    return BlocBuilder<QrcodeCubit, QrcodeState>(
      builder: (context, state) {
        return Stack(
          children: [
            // Camera view
            MobileScanner(
              controller: cameraController,
              onDetect: (capture) => _onDetect(capture, context),
            ),

            // Dark overlay with hole in center
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 260.w,
                      height: 260.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Blue border frame
            Center(
              child: Container(
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0F6BFA), width: 3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),

            // ✅ Zoom slider
            Positioned(
              bottom: 160.h,
              left: 40.w,
              right: 40.w,
              child: Row(
                children: [
                  Icon(Icons.zoom_out, color: Colors.white, size: 20.sp),
                  Expanded(
                    child: Slider(
                      value: _zoomFactor,
                      min: 0.0,
                      max: 1.0,
                      activeColor: const Color(0xFF0F6BFA),
                      inactiveColor: Colors.white38,
                      onChanged: (value) {
                        setState(() => _zoomFactor = value);
                        cameraController.setZoomScale(value);
                      },
                    ),
                  ),
                  Icon(Icons.zoom_in, color: Colors.white, size: 20.sp),
                ],
              ),
            ),

            // Instructions / loading
            Positioned(
              bottom: 80.h,
              left: 0,
              right: 0,
              child: Center(
                child: state is QrcodeLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Column(
                        children: [
                          Icon(
                            hasScanned
                                ? Icons.check_circle_outline
                                : Icons.qr_code_scanner,
                            color: Colors.white,
                            size: 32.sp,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            hasScanned
                                ? "Traitement en cours..."
                                : "Pointez la caméra vers le QR code",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 80.sp, color: Colors.white54),
            SizedBox(height: 20.h),
            Text(
              "Accès à la caméra requis",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              "Veuillez autoriser l'accès à la caméra pour scanner le QR code",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 14.sp),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: _requestCameraPermission,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F6BFA),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                "Autoriser la caméra",
                style: TextStyle(color: Colors.white, fontSize: 15.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
