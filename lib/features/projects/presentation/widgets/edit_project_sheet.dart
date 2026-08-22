import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/presentation/bloc/projects_bloc.dart';

class EditProjectSheet extends StatefulWidget {
  const EditProjectSheet({
    super.key,
    required this.project,
    required this.session,
  });

  final ProjectEntity project;
  final UserSessionEntity session;

  @override
  State<EditProjectSheet> createState() => _EditProjectSheetState();
}

class _EditProjectSheetState extends State<EditProjectSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(
      text: widget.project.description,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ProjectsBloc>().add(
      ProjectUpdateRequested(
        projectId: widget.project.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        session: widget.session,
      ),
    );
    Navigator.pop(context);
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('EDIT PROJECT', style: AppText.display(size: 24.sp)),
            SizedBox(height: 24.h),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'PROJECT NAME'),
              validator: (value) =>
                  value?.trim().isEmpty ?? true ? 'Name required' : null,
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(hintText: 'DESCRIPTION'),
              maxLines: 3,
              validator: (value) =>
                  value?.trim().isEmpty ?? true ? 'Description required' : null,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('SAVE CHANGES'),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
