part of 'team_bloc.dart';

sealed class TeamEvent extends Equatable {
  const TeamEvent();

  @override
  List<Object?> get props => [];
}

final class TeamMembersLoadRequested extends TeamEvent {
  const TeamMembersLoadRequested(this.session);

  final UserSessionEntity session;

  @override
  List<Object?> get props => [session];
}
