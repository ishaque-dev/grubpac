import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/theme/app_theme.dart';
import 'package:grubpac/features/projects/presentation/bloc/projects_bloc.dart';

class CreateProjectSheet extends StatefulWidget {
  const CreateProjectSheet({super.key, required this.session});

  final UserSessionEntity session;

  @override
  State<CreateProjectSheet> createState() => _CreateProjectSheetState();
}

class _CreateProjectSheetState extends State<CreateProjectSheet> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProjectsBloc>().add(
            ProjectCreateRequested(
              name: _nameController.text.trim(),
              description: _descController.text.trim(),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NEW PROJECT',
              style: AppText.display(size: 24.sp),
            ),
            SizedBox(height: 24.h),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'PROJECT NAME'),
              style: AppText.body(),
              validator: (value) => value?.isEmpty ?? true ? 'Name required' : null,
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _descController,
              decoration: const InputDecoration(hintText: 'DESCRIPTION'),
              style: AppText.body(),
              maxLines: 3,
              validator: (value) => value?.isEmpty ?? true ? 'Description required' : null,
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSubmit,
                child: const Text('CREATE PROJECT'),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
