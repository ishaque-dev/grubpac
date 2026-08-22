import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show Bloc, Emitter;
import 'package:grubpac/core/session/user_session_entity.dart';
import 'package:grubpac/core/usecase/use_case.dart';
import 'package:grubpac/features/auth/domain/entities/auth_request_entity.dart';
import 'package:grubpac/features/auth/domain/use_cases/get_saved_session_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/login_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/logout_use_case.dart';
import 'package:grubpac/features/auth/domain/use_cases/refresh_session_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this._getSavedSession,
    required this._login,
    required this._logout,
    required this._refreshSession,
  }) : super(AuthInitial()) {
    on<AuthSessionRequested>(_onSessionRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthRefreshRequested>(_onRefreshRequested);
  }

  final GetSavedSessionUseCase _getSavedSession;
  final LoginUseCase _login;
  final LogoutUseCase _logout;
  final RefreshSessionUseCase _refreshSession;
  Timer? _refreshTimer;

  Future<void> _onSessionRequested(
    AuthSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _getSavedSession(parameters: NoParam());
    result.fold((failure) => emit(AuthFailure(failure.message)), (
      session,
    ) async {
      if (session == null) {
        emit(AuthUnauthenticated());
      } else if (session.isAccessTokenExpired &&
          !session.isRefreshTokenExpired) {
        await _refresh(emit);
      } else {
        _emitAuthenticated(session, emit);
      }
    });
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _login(
      parameters: AuthRequestEntity(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (session) => _emitAuthenticated(session, emit),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logout(parameters: NoParam());
    result.fold((failure) => emit(AuthFailure(failure.message)), (_) {
      _refreshTimer?.cancel();
      emit(AuthUnauthenticated());
    });
  }

  Future<void> _onRefreshRequested(
    AuthRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) {
      emit(AuthLoading());
    }
    await _refresh(emit);
  }

  Future<void> _refresh(Emitter<AuthState> emit) async {
    final result = await _refreshSession(parameters: NoParam());
    result.fold((failure) {
      _refreshTimer?.cancel();
      emit(AuthFailure(failure.message));
    }, (session) => _emitAuthenticated(session, emit));
  }

  void _emitAuthenticated(UserSessionEntity session, Emitter<AuthState> emit) {
    emit(AuthAuthenticated(session));
    _scheduleRefresh(session);
  }

  void _scheduleRefresh(UserSessionEntity session) {
    _refreshTimer?.cancel();
    if (session.isRefreshTokenExpired) return;
    final refreshIn = session.accessTokenExpiresAt
        .subtract(const Duration(seconds: 30))
        .difference(DateTime.now());
    _refreshTimer = Timer(
      refreshIn.isNegative || refreshIn == Duration.zero
          ? const Duration(seconds: 1)
          : refreshIn,
      () => add(AuthRefreshRequested()),
    );
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}
