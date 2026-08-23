import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/notifications/domain/entities/notification_entity.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
    this.onToggleRead,
  });

  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onToggleRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: notification.hasRead ? Colors.transparent : AppColors.limeDim,
        border: Border.all(
          color: notification.hasRead ? AppColors.line : AppColors.lime,
          width: notification.hasRead ? 1 : 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.message.toUpperCase(),
                      style: AppText.display(
                        size: 16.sp,
                        color: notification.hasRead ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      notification.createdAt,
                      style: AppText.mono(size: 10.sp, color: AppColors.textFaint),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleRead,
                tooltip: notification.hasRead ? AppUiStrings.markAsUnread : AppUiStrings.markAsRead,
                icon: Icon(
                  notification.hasRead ? Icons.mark_email_read_outlined : Icons.mark_email_unread_outlined,
                  color: notification.hasRead ? AppColors.textFaint : AppColors.lime,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
