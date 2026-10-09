import 'package:admin/core/styling/app_colors.dart';
import 'package:admin/core/utils/snack_bar.dart';
import 'package:admin/features/historique_notification/cubit/mark_read_cubit.dart';
import 'package:admin/features/historique_notification/cubit/mark_red_state.dart';
import 'package:admin/features/historique_notification/cubit/notification_cubit.dart';
import 'package:admin/features/historique_notification/cubit/notification_state.dart';
import 'package:admin/features/historique_notification/cubit/reply_cubit.dart';
import 'package:admin/features/historique_notification/cubit/reply_state.dart';
import 'package:admin/features/main_screen/widget/custom_app_bar.dart';
import 'package:admin/features/tableau_board/tableau_board_screen.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_effect/shimmer_effect.dart';
import 'model/notification_model.dart';
import 'widget/notification_detail_view.dart';
import 'widget/notification_list_item.dart';
import 'widget/notification_reply_view.dart';

enum _NotifView { liste, detail, repondre }

class HistoriqueNotificationScreen extends StatefulWidget {
  const HistoriqueNotificationScreen({super.key});

  @override
  State<HistoriqueNotificationScreen> createState() =>
      _HistoriqueNotificationScreenState();
}

class _HistoriqueNotificationScreenState
    extends State<HistoriqueNotificationScreen> {
  _NotifView _currentView = _NotifView.liste;
  NotificationModel? _selectedNotification;

  String get _appBarTitle {
    switch (_currentView) {
      case _NotifView.liste:
        return 'Historique de Notification';
      case _NotifView.detail:
        return 'Voir le détail';
      case _NotifView.repondre:
        return 'Répondre au message';
    }
  }

  void _goToDetail(NotificationModel notif) {
    // Marquer comme lu au moment d'ouvrir le détail
    context.read<MarkAsReadCubit>().markAsRead(notif.id);
    setState(() {
      _selectedNotification = notif;
      _currentView = _NotifView.detail;
    });
  }

  void _goToReply() {
    setState(() => _currentView = _NotifView.repondre);
  }

  void _backToListe() {
    //  context.read<GetNotificationsCubit>().getNotifications();
    setState(() {
      _currentView = _NotifView.liste;
      _selectedNotification = null;
    });
  }

  void _backToDetail() {
    setState(() => _currentView = _NotifView.detail);
  }

  void _handleEnvoyer(String titre, String description) {
    context.read<SendNotificationCubit>().sendNotification(
      targetAuthId: _selectedNotification!.authId,
      titre: titre,
      message: description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // ── Send notification listener ──
        BlocListener<SendNotificationCubit, SendNotificationState>(
          listener: (context, state) {
            if (state is SendNotificationSuccessState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: 'Message envoyé avec succès.',
                type: AnimatedSnackBarType.success,
              );
              context.read<GetNotificationsCubit>().getNotifications();

              setState(() {
                _currentView = _NotifView.liste;
                _selectedNotification = null;
              });
            } else if (state is SendNotificationErrorState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
        // ── Mark as read listener (silencieux) ──
        BlocListener<MarkAsReadCubit, MarkAsReadState>(
          listener: (context, state) {
            if (state is MarkAsReadErrorState) {
              ShowSnackBar.showAnimatedSnackDialog(
                context: context,
                message: state.error,
                type: AnimatedSnackBarType.error,
              );
            }
          },
        ),
      ],
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: CustomAppBar(title: _appBarTitle, showProfileSection: false),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
            child: _buildCurrentView(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case _NotifView.liste:
        return _buildListView();
      case _NotifView.detail:
        return NotificationDetailView(
          notification: _selectedNotification!,
          onBack: _backToListe,
          onRepondre: _goToReply,
        );
      case _NotifView.repondre:
        return BlocBuilder<SendNotificationCubit, SendNotificationState>(
          builder: (context, state) {
            if (state is SendNotificationLoadingState) {}
            return NotificationReplyView(
              onBack: _backToDetail,
              onEnvoyer: _handleEnvoyer,
            );
          },
        );
    }
  }

  Widget _buildListView() {
    return BlocBuilder<GetNotificationsCubit, GetNotificationsState>(
      builder: (context, state) {
        if (state is GetNotificationsLoadingState) {
          return Padding(
            padding: EdgeInsets.all(30.h),
            child: ShimmerEffect(
              baseColor: const Color(0xFFDCE8F7),
              highlightColor: Colors.white,
              child: Column(
                children: List.generate(
                  6,
                  (index) => Container(
                    width: double.infinity,
                    height: 200.h,
                    margin: EdgeInsets.only(bottom: 20.h),
                    padding: EdgeInsets.all(30.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCE8F7),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (state is GetNotificationsErrorState) {
          return ErrorS(
            message: state.error,
            onRetry: () {
              context.read<GetNotificationsCubit>().getNotifications();
            },
          );
        }

        if (state is GetNotificationsSuccessState) {
          if (state.notifications.isEmpty) {
            return ErrorS(
              message: "Aucune notification",
              onRetry: () {
                context.read<GetNotificationsCubit>().getNotifications();
              },
            );
          }
          return Column(
            children: state.notifications
                .map(
                  (notif) => NotificationListItem(
                    notification: notif,
                    onVoirDetail: () => _goToDetail(notif),
                  ),
                )
                .toList(),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
