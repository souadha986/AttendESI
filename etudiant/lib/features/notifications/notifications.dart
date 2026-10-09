import 'package:etudiant/core/navigation/app_routes.dart';
import 'package:etudiant/core/styling/app_colors.dart';
import 'package:etudiant/core/styling/app_styles.dart';
import 'package:etudiant/core/widgets/spacing.dart';
import 'package:etudiant/features/notifications/cubit/notification_cubit.dart';
import 'package:etudiant/features/notifications/cubit/notification_state.dart';
import 'package:etudiant/features/notifications/model/notification_model.dart';
import 'package:etudiant/features/notifications/widget/aucune_notification.dart';
import 'package:etudiant/features/notifications/widget/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer_effect/shimmer_effect.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsCubit>().getNotifications();
  }

  String _resolveTarget(NotificationModel item) {
    if (item.isGlobal) return "Global";

    final parts = [
      if (item.targetSituation != null && item.targetSituation != "NULL")
        item.targetSituation!,
      if (item.targetGroup != null) "Groupe ${item.targetGroup}",
    ];

    if (parts.isNotEmpty) return parts.join(" / ");

    if (item.targetStudentId != null) return "Vous";

    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique de Notification", style: AppStyles.blueA20w700),
        centerTitle: true,
        backgroundColor: AppColors.greyColor,
        elevation: 0,
        toolbarHeight: 80.h,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 17.w),
        child: Column(
          children: [
            HeightSpace(20),
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return ListView.builder(
                      itemCount: 6,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: ShimmerEffect(
                            baseColor: AppColors.greyColor,
                            highlightColor: AppColors.lightGreyColor,
                            child: Container(
                              padding: EdgeInsets.all(16.sp),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title row with icon
                                  Row(
                                    children: [
                                      Container(
                                        width: 18.w,
                                        height: 18.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                      WidthSpace(8),
                                      Container(
                                        width: 140.w,
                                        height: 16.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  HeightSpace(10),
                                  // From
                                  Container(
                                    width: 120.w,
                                    height: 13.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                  HeightSpace(6),
                                  // To
                                  Container(
                                    width: 90.w,
                                    height: 13.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                  ),
                                  HeightSpace(10),
                                  // Bottom row: time + "Voir la notification"
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 50.w,
                                        height: 13.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 110.w,
                                        height: 13.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            6.r,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (state is NotificationError) {
                    return AucuneNotification(
                      title1: "Une erreur est survenue",
                      title2: "Veuillez vérifier votre connexion et réessayer",
                    );
                  }
                  if (state is NotificationLoaded) {
                    final List<NotificationModel> notifications =
                        state.notifications;

                    if (notifications.isEmpty) {
                      return AucuneNotification(
                        title1: "Aucune notification pour le moment",
                        title2:
                            "Vous serez informé dès qu’un changement survient",
                      );
                    }

                    return RefreshIndicator(
                      backgroundColor: AppColors.whiteColor,
                      color: AppColors.blueColorE,
                      onRefresh: () async =>
                          context.read<NotificationsCubit>().getNotifications(),
                      child: ListView.builder(
                        itemCount: notifications.length,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          final item = notifications[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 14.h),
                            child: NotificationCard(
                              title: item.title,
                              from: item.from,
                              time:
                                  "${item.createdAt.day.toString().padLeft(2, '0')}/${item.createdAt.month.toString().padLeft(2, '0')}/${item.createdAt.year}",
                              to: _resolveTarget(item),
                              onTap: () {
                                context.pushNamed(
                                  AppRoutes.notificationdetails,
                                  extra: {
                                    "title": item.title,
                                    "from": item.from,
                                    "date":
                                        "${item.createdAt.day.toString().padLeft(2, '0')}/${item.createdAt.month.toString().padLeft(2, '0')}/${item.createdAt.year}",
                                    "message": item.content,
                                    "to": _resolveTarget(item),
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
