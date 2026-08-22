import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final ProjectEntity project;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        customBorder: const CutCornerBorder(cut: 16),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.name.toUpperCase(),
                      style: AppText.display(size: 20.sp),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StatusChip(status: project.status),
                      if (onEdit != null || onDelete != null)
                        PopupMenuButton<String>(
                          tooltip: AppUiStrings.projectActions,
                          onSelected: (value) {
                            if (value == 'edit') onEdit?.call();
                            if (value == 'delete') onDelete?.call();
                          },
                          itemBuilder: (context) => [
                            if (onEdit != null)
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text(AppUiStrings.edit),
                              ),
                            if (onDelete != null)
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text(AppUiStrings.deleteProject),
                              ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                project.description,
                style: AppText.body(size: 13.sp, color: AppColors.textMuted),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 14.sp,
                    color: AppColors.lime,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '${project.taskCount} TASKS',
                    style: AppText.mono(
                      size: 11.sp,
                      color: AppColors.lime,
                      weight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'CREATED ${project.createdAt.day}/${project.createdAt.month}/${project.createdAt.year}',
                    style: AppText.mono(
                      size: 10.sp,
                      color: AppColors.textFaint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status.toLowerCase() == 'active'
        ? AppColors.lime
        : AppColors.textMuted;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppText.mono(size: 9.sp, color: color, weight: FontWeight.w700),
      ),
    );
  }
}
