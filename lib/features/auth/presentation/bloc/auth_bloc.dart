import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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

  Future<void> _onSessionRequested(
    AuthSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _getSavedSession(parameters: NoParam());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (session) => emit(
        session == null ? AuthUnauthenticated() : AuthAuthenticated(session),
      ),
    );
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
      (session) => emit(AuthAuthenticated(session)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _logout(parameters: NoParam());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> _onRefreshRequested(
    AuthRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _refreshSession(parameters: NoParam());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (session) => emit(AuthAuthenticated(session)),
    );
  }
}
