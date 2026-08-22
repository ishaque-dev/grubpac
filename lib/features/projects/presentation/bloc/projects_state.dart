part of 'projects_bloc.dart';

sealed class ProjectsState extends Equatable {
  const ProjectsState();

  @override
  List<Object?> get props => [];
}

final class ProjectsInitial extends ProjectsState {}

final class ProjectsLoading extends ProjectsState {}

final class ProjectsLoaded extends ProjectsState {
  const ProjectsLoaded({
    required this.projects,
    this.selectedProject,
    this.message,
  });

  final List<ProjectEntity> projects;
  final ProjectEntity? selectedProject;
  final String? message;

  ProjectsLoaded copyWith({
    List<ProjectEntity>? projects,
    ProjectEntity? selectedProject,
    bool clearSelectedProject = false,
  }) {
    return ProjectsLoaded(
      projects: projects ?? this.projects,
      selectedProject: clearSelectedProject
          ? null
          : selectedProject ?? this.selectedProject,
    );
  }

  @override
  List<Object?> get props => [projects, selectedProject, message];
}

final class ProjectsFailure extends ProjectsState {
  const ProjectsFailure(this.message, {this.projects = const []});

  final String message;
  final List<ProjectEntity> projects;

  @override
  List<Object> get props => [message, projects];
}
