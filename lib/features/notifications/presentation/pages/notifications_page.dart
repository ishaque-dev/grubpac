import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';
import 'package:grubpac/features/notifications/presentation/bloc/notification_bloc.dart';
import 'package:grubpac/features/notifications/presentation/widgets/notification_tile.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, required this.session});

  final UserSessionEntity session;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(NotificationsLoadRequested(widget.session));
  }

  void _onToggleRead(NotificationEntity notification) {
    context.read<NotificationBloc>().add(
          NotificationToggleReadRequested(
            session: widget.session,
            notification: notification,
          ),
        );
  }

  void _markAllAsRead(List<NotificationEntity> notifications) {
    for (final n in notifications) {
      if (!n.hasRead) {
        _onToggleRead(n);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppUiStrings.notifications, style: AppText.display(size: 24.sp)),
        centerTitle: false,
        actions: [
          BlocBuilder<NotificationBloc, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.notifications.any((n) => !n.hasRead)) {
                return TextButton(
                  onPressed: () => _markAllAsRead(state.notifications),
                  child: Text(
                    AppUiStrings.markAllAsRead,
                    style: AppText.mono(size: 11.sp, color: AppColors.lime, weight: FontWeight.bold),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          SizedBox(width: 12.w),
        ],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.lime));
          }

          if (state is NotificationFailure) {
            return Center(
              child: Text(state.message, style: AppText.body(color: AppColors.danger)),
            );
          }

          if (state is NotificationLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_none, size: 64.sp, color: AppColors.textFaint),
                    SizedBox(height: 16.h),
                    Text(
                      AppUiStrings.allCaughtUp,
                      style: AppText.mono(size: 14.sp, color: AppColors.textMuted),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.lime,
              onRefresh: () async {
                context.read<NotificationBloc>().add(NotificationsLoadRequested(widget.session));
              },
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return NotificationTile(
                    notification: notification,
                    onToggleRead: () => _onToggleRead(notification),
                    onTap: () {
                      // Navigate to task or detail if needed
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
