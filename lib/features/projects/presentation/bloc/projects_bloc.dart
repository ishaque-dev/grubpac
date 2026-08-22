import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grubpac/core/constants/app_strings.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/projects/domain/entities/create_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/entities/project_entity.dart';
import 'package:grubpac/features/projects/domain/entities/update_project_request_entity.dart';
import 'package:grubpac/features/projects/domain/params/project_params.dart';
import 'package:grubpac/features/projects/domain/use_cases/create_project_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/delete_project_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/get_project_by_id_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/get_projects_use_case.dart';
import 'package:grubpac/features/projects/domain/use_cases/update_project_use_case.dart';

part 'projects_event.dart';
part 'projects_state.dart';

class ProjectsBloc extends Bloc<ProjectsEvent, ProjectsState> {
  ProjectsBloc({
    required this._getProjects,
    required this._getProjectById,
    required this._createProject,
    required this._updateProject,
    required this._deleteProject,
  }) : super(ProjectsInitial()) {
    on<ProjectsLoadRequested>(_onLoadRequested);
    on<ProjectLoadRequested>(_onProjectLoadRequested);
    on<ProjectCreateRequested>(_onCreateRequested);
    on<ProjectUpdateRequested>(_onUpdateRequested);
    on<ProjectDeleteRequested>(_onDeleteRequested);
  }

  final GetProjectsUseCase _getProjects;
  final GetProjectByIdUseCase _getProjectById;
  final CreateProjectUseCase _createProject;
  final UpdateProjectUseCase _updateProject;
  final DeleteProjectUseCase _deleteProject;

  Future<void> _onLoadRequested(
    ProjectsLoadRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    emit(ProjectsLoading());
    final result = await _getProjects(parameters: event.session);
    result.fold(
      (failure) => emit(ProjectsFailure(failure.message)),
      (projects) => emit(ProjectsLoaded(projects: projects)),
    );
  }

  Future<void> _onProjectLoadRequested(
    ProjectLoadRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final previous = state is ProjectsLoaded
        ? (state as ProjectsLoaded).projects
        : const <ProjectEntity>[];
    emit(ProjectsLoading());
    final result = await _getProjectById(
      parameters: GetProjectByIdParams(
        projectId: event.projectId,
        session: event.session,
      ),
    );
    result.fold(
      (failure) => emit(ProjectsFailure(failure.message, projects: previous)),
      (project) =>
          emit(ProjectsLoaded(projects: previous, selectedProject: project)),
    );
  }

  Future<void> _onCreateRequested(
    ProjectCreateRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final previous = _projects;
    emit(ProjectsLoading());
    final result = await _createProject(
      parameters: CreateProjectParams(
        request: CreateProjectRequestEntity(
          name: event.name,
          description: event.description,
        ),
        session: event.session,
      ),
    );
    result.fold(
      (failure) => emit(ProjectsFailure(failure.message, projects: previous)),
      (project) => emit(
        ProjectsLoaded(
          projects: [...previous, project],
          message: AppUiStrings.projectCreated,
        ),
      ),
    );
  }

  Future<void> _onUpdateRequested(
    ProjectUpdateRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final previous = _projects;
    emit(ProjectsLoading());
    final result = await _updateProject(
      parameters: UpdateProjectParams(
        request: UpdateProjectRequestEntity(
          projectId: event.projectId,
          name: event.name,
          description: event.description,
          status: event.status,
        ),
        session: event.session,
      ),
    );
    result.fold(
      (failure) => emit(ProjectsFailure(failure.message, projects: previous)),
      (project) => emit(
        ProjectsLoaded(
          projects: [
            for (final current in previous)
              if (current.id == project.id) project else current,
          ],
          selectedProject: project,
          message: AppUiStrings.projectUpdated,
        ),
      ),
    );
  }

  Future<void> _onDeleteRequested(
    ProjectDeleteRequested event,
    Emitter<ProjectsState> emit,
  ) async {
    final previous = _projects;
    emit(ProjectsLoading());
    final result = await _deleteProject(
      parameters: DeleteProjectParams(
        projectId: event.projectId,
        session: event.session,
      ),
    );
    result.fold(
      (failure) => emit(ProjectsFailure(failure.message, projects: previous)),
      (_) => emit(
        ProjectsLoaded(
          projects: previous
              .where((project) => project.id != event.projectId)
              .toList(),
          message: AppUiStrings.projectDeleted,
        ),
      ),
    );
  }

  List<ProjectEntity> get _projects => state is ProjectsLoaded
      ? (state as ProjectsLoaded).projects
      : state is ProjectsFailure
      ? (state as ProjectsFailure).projects
      : const <ProjectEntity>[];
}
