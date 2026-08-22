import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';

class GetProjectByIdParams {
  final String projectId;
  final UserSessionEntity session;

  const GetProjectByIdParams({required this.projectId, required this.session});
}

class CreateProjectParams {
  final CreateProjectRequestEntity request;
  final UserSessionEntity session;

  const CreateProjectParams({required this.request, required this.session});
}

class UpdateProjectParams {
  final UpdateProjectRequestEntity request;
  final UserSessionEntity session;

  const UpdateProjectParams({required this.request, required this.session});
}

class DeleteProjectParams {
  final String projectId;
  final UserSessionEntity session;

  const DeleteProjectParams({required this.projectId, required this.session});
}
