import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/shared/enums.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/core/utils/app_validators.dart';
import 'package:grubpac/features/tasks/domain/entities/task_entity.dart';
import 'package:grubpac/features/tasks/presentation/bloc/task_bloc.dart';

class CreateTaskSheet extends StatefulWidget {
  const CreateTaskSheet({
    super.key,
    required this.projectId,
    required this.session,
  });

  final String projectId;
  final UserSessionEntity session;

  @override
  State<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends State<CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  TaskStatus _status = TaskStatus.todo;
  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: AppTheme.dark.copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.lime,
              onPrimary: AppColors.bg,
              surface: AppColors.card,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<TaskBloc>().add(
        TaskCreateRequested(
          task: TaskEntity(
            projectId: widget.projectId,
            title: _titleController.text.trim(),
            description: _descController.text.trim(),
            status: _status,
            priority: _priority,
            dueDate: _dueDate,
            createdAt: DateTime.now(),
          ),
          session: widget.session,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24.w,
        right: 24.w,
        top: 24.h,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppUiStrings.newTask, style: AppText.display(size: 24.sp)),
              SizedBox(height: 24.h),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: AppUiStrings.taskTitle,
                ),
                style: AppText.body(),
                validator: AppValidators.titleValidator,
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  hintText: AppUiStrings.description,
                ),
                style: AppText.body(),
                maxLines: 3,
                validator: AppValidators.descriptionValidator,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _DropdownField<TaskStatus>(
                      label: AppUiStrings.status,
                      value: _status,
                      items: TaskStatus.values,
                      onChanged: (v) => setState(() => _status = v!),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: _DropdownField<TaskPriority>(
                      label: AppUiStrings.priority,
                      value: _priority,
                      items: TaskPriority.values,
                      onChanged: (v) => setState(() => _priority = v!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppUiStrings.dueDate,
                        style: AppText.body(color: AppColors.textFaint),
                      ),
                      const Spacer(),
                      Text(
                        '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                        style: AppText.mono(
                          color: AppColors.lime,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text(AppUiStrings.createTask),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownField<T extends Enum> extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppText.mono(size: 10.sp, color: AppColors.textFaint),
        ),
        SizedBox(height: 4.h),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e.name.toUpperCase(),
                    style: AppText.mono(size: 12.sp),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          dropdownColor: AppColors.card,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.lime),
        ),
      ],
    );
  }
}
