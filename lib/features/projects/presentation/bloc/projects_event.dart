part of 'projects_bloc.dart';

sealed class ProjectsEvent extends Equatable {
  const ProjectsEvent();

  @override
  List<Object?> get props => [];
}

final class ProjectsLoadRequested extends ProjectsEvent {
  const ProjectsLoadRequested(this.session);

  final UserSessionEntity session;

  @override
  List<Object> get props => [session];
}

final class ProjectLoadRequested extends ProjectsEvent {
  const ProjectLoadRequested({required this.projectId, required this.session});

  final String projectId;
  final UserSessionEntity session;

  @override
  List<Object> get props => [projectId, session];
}

final class ProjectCreateRequested extends ProjectsEvent {
  const ProjectCreateRequested({
    required this.name,
    required this.description,
    required this.session,
  });

  final String name;
  final String description;
  final UserSessionEntity session;

  @override
  List<Object> get props => [name, description, session];
}

final class ProjectUpdateRequested extends ProjectsEvent {
  const ProjectUpdateRequested({
    required this.projectId,
    required this.session,
    this.name,
    this.description,
    this.status,
  });

  final String projectId;
  final UserSessionEntity session;
  final String? name;
  final String? description;
  final String? status;

  @override
  List<Object?> get props => [projectId, session, name, description, status];
}

final class ProjectDeleteRequested extends ProjectsEvent {
  const ProjectDeleteRequested({
    required this.projectId,
    required this.session,
  });

  final String projectId;
  final UserSessionEntity session;

  @override
  List<Object> get props => [projectId, session];
}
