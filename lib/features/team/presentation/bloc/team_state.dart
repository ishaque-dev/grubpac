part of 'team_bloc.dart';

sealed class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object?> get props => [];
}

final class TeamInitial extends TeamState {}

final class TeamLoading extends TeamState {}

final class TeamLoaded extends TeamState {
  const TeamLoaded({required this.members});

  final List<MemberEntity> members;

  @override
  List<Object?> get props => [members];
}

final class TeamFailure extends TeamState {
  const TeamFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
