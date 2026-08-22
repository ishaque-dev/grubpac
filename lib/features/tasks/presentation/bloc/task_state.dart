part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {}

final class TaskLoading extends TaskState {}

final class TaskLoaded extends TaskState {
  const TaskLoaded({required this.tasks, this.selectedTask, this.message});

  final List<TaskEntity> tasks;
  final TaskEntity? selectedTask;
  final String? message;

  @override
  List<Object?> get props => [tasks, selectedTask, message];
}

final class TaskFailure extends TaskState {
  const TaskFailure(this.message, {this.tasks = const []});

  final String message;
  final List<TaskEntity> tasks;

  @override
  List<Object> get props => [message, tasks];
}
