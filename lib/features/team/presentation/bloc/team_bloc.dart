import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/features/team/domain/entities/member_entity.dart';
import 'package:grubpac/features/team/domain/use_cases/get_members_use_case.dart';

part 'team_event.dart';
part 'team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {
  TeamBloc({required this._getMembers})
    : super(TeamInitial()) {
    on<TeamMembersLoadRequested>(_onLoadRequested);
  }

  final GetMembersUseCase _getMembers;

  Future<void> _onLoadRequested(
    TeamMembersLoadRequested event,
    Emitter<TeamState> emit,
  ) async {
    emit(TeamLoading());
    final result = await _getMembers(parameters: event.session);
    result.fold(
      (failure) => emit(TeamFailure(failure.message)),
      (members) => emit(TeamLoaded(members: members)),
    );
  }
}
