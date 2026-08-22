import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onStatusTap,
    this.onPriorityTap,
    this.onDelete,
  });

  final TaskEntity task;
  final VoidCallback? onStatusTap;
  final VoidCallback? onPriorityTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title.toUpperCase(),
                    style: AppText.display(size: 18.sp),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18.sp,
                    color: AppColors.textFaint,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              task.description,
              style: AppText.body(size: 13.sp, color: AppColors.textMuted),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                _ActionChip(
                  label: task.status.name.toUpperCase(),
                  color: _getStatusColor(task.status),
                  onTap: onStatusTap,
                ),
                SizedBox(width: 8.w),
                _ActionChip(
                  label: task.priority.name.toUpperCase(),
                  color: _getPriorityColor(task.priority),
                  onTap: onPriorityTap,
                ),
                const Spacer(),
                Icon(
                  Icons.calendar_today,
                  size: 12.sp,
                  color: AppColors.textFaint,
                ),
                SizedBox(width: 4.w),
                Text(
                  '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                  style: AppText.mono(size: 10.sp, color: AppColors.textFaint),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return AppColors.textMuted;
      case TaskStatus.inProgress:
        return AppColors.orange;
      case TaskStatus.review:
        return AppColors.orange;
      case TaskStatus.done:
        return AppColors.success;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return AppColors.success;
      case TaskPriority.medium:
        return AppColors.orange;
      case TaskPriority.high:
        return AppColors.orange;
      case TaskPriority.urgent:
        return AppColors.danger;
    }
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.label, required this.color, this.onTap});

  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: AppText.mono(
            size: 9.sp,
            color: color,
            weight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
