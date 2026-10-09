import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scolarite/core/assets/images.dart';
import 'package:scolarite/core/styling/app_styles.dart';
import 'package:scolarite/core/widgets/spacing.dart';
import 'package:scolarite/features/historique_notification/cubit/notif_cubit.dart';
import 'package:scolarite/features/historique_notification/cubit/notif_state.dart';
import 'package:scolarite/features/historique_notification/models/notif_models.dart';

class NotificationModel {
  final String name;
  final String message;
  NotificationModel({required this.name, required this.message});
}

class NotificationCard extends StatelessWidget {
  final NotificationModel data;
  final VoidCallback onTap;

  const NotificationCard({super.key, required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700.w,
      height: 270.h,
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2FF),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xff0969BB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff3A3A3A),
            ),
          ),
          HeightSpace(20),
          Container(
            width: 660.w,
            height: 100.h,
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: const Color(0xffFAFCFE),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xff0969BB), width: 0.5.w),
            ),
            child: Text(
              data.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          HeightSpace(20),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: 140.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: const Color(0xffFAFCFE),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(color: const Color(0xff0969BB)),
                ),
                child: Center(
                  child: Text(
                    "Voir details",
                    style: GoogleFonts.poppins(
                      color: const Color(0xff0969BB),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationDetails extends StatelessWidget {
  final NotificationModel data;
  final VoidCallback onBack;

  const NotificationDetails({
    super.key,
    required this.data,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F2FF),
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(color: const Color(0xff0969BB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name,
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff3A3A3A),
            ),
          ),
          HeightSpace(16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xffFAFCFE),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: const Color(0xff0969BB), width: 0.5.w),
            ),
            child: Text(data.message, style: TextStyle(fontSize: 15.sp)),
          ),
          HeightSpace(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WidthSpace(10),
              TextButton(
                onPressed: onBack,
                child: Text(
                  "Retour",
                  style: TextStyle(color: const Color(0xff6095E8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HistoriqueNotificationScreen extends StatefulWidget {
  const HistoriqueNotificationScreen({super.key});

  @override
  State<HistoriqueNotificationScreen> createState() =>
      _HistoriqueNotificationScreenState();
}

class _HistoriqueNotificationScreenState
    extends State<HistoriqueNotificationScreen> {
  String? _globalError;

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
    context.read<NotifCubit>().getNotifications();
  }

  NotificationModel? selectedNotification;

  List<NotificationModel> mapNotifications(List<Message> messages) {
    return messages.map((msg) {
      return NotificationModel(
        name: msg.sender ?? '',
        message: msg.content ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotifCubit, NotifState>(
      listener: (context, state) {
        if (state is NotifErrorState) {
          _setError(state.error);
        } else if (state is NotifSuccessState) {
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
                  Text(
                    "Historique de Notifications",
                    style: AppStyles.blueBBw800,
                  ),

                  HeightSpace(100),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 700.w,
                        child: _globalError != null
                            ? _StateBox(
                                icon: Icons.error_outline_rounded,
                                iconColor: Colors.red.withOpacity(0.7),
                                message: _globalError!,
                                buttonLabel: 'Réessayer',
                                buttonIcon: Icons.refresh,
                                onPressed: _retry,
                              )
                            : _buildBody(),
                      ),
                    ),
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
    return BlocBuilder<NotifCubit, NotifState>(
      builder: (context, state) {
        if (state is NotifLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xff6095E8)),
          );
        }

        if (state is NotifSuccessState) {
          final notifications = mapNotifications(state.notif.messages);

          if (notifications.isEmpty) {
            return Center(
              child: _StateBox(
                icon: Icons.notifications_off_outlined,
                iconColor: const Color(0xFF828282).withOpacity(0.5),
                message: "Aucune notification",
                buttonLabel: 'Actualiser',
                buttonIcon: Icons.refresh,
                onPressed: _retry,
              ),
            );
          }

          return SizedBox(
            height: 800.h,
            child: selectedNotification == null
                ? ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationCard(
                        data: notifications[index],
                        onTap: () {
                          setState(
                            () => selectedNotification = notifications[index],
                          );
                        },
                      );
                    },
                  )
                : NotificationDetails(
                    data: selectedNotification!,
                    onBack: () {
                      setState(() => selectedNotification = null);
                    },
                  ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class _StateBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String message;
  final String buttonLabel;
  final IconData buttonIcon;
  final VoidCallback onPressed;

  const _StateBox({
    required this.icon,
    required this.iconColor,
    required this.message,
    required this.buttonLabel,
    required this.buttonIcon,
    required this.onPressed,
  });

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
            Icon(icon, size: 42.sp, color: iconColor),
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
              onPressed: onPressed,
              icon: Icon(buttonIcon),
              label: Text(buttonLabel),
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
