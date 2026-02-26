import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entites/auth_session_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _auth = authRepository,
        super(AuthState.initial) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthOrganizationUrlSubmitted>(_onOrganizationUrlSubmitted);
    on<AuthBiometricRequested>(_onBiometricRequested);
  }

  final AuthRepository _auth;


  bool get isLoading => state is AuthStateLoading;

  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading);
    try {
      final session = await _auth.getSession();
      if (session != null) {
        emit(AuthState.authenticated(session));
      } else {
        final inviteUrl = await _auth.getOrganizationInviteUrl();
        if (inviteUrl != null && inviteUrl.isNotEmpty) {
          emit(AuthState.unauthenticated(hasOrgUrl: true));
        } else {
          emit(AuthState.unauthenticated(hasOrgUrl: false));
        }
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading);
    try {
    
      final session = await _auth.login(event.username, event.password);
      if (session != null) {
        emit(AuthState.authenticated(session));
      } else {
        emit(AuthState.failure('Invalid credentials'));
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _auth.clearSession();
    emit(AuthState.unauthenticated(hasOrgUrl: true));
  }

  Future<void> _onOrganizationUrlSubmitted(AuthOrganizationUrlSubmitted event, Emitter<AuthState> emit) async {
    emit(AuthState.loading);
    try {
      await _auth.saveOrganizationInviteUrl(event.url);
      emit(AuthState.unauthenticated(hasOrgUrl: true));
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }

  Future<void> _onBiometricRequested(AuthBiometricRequested event, Emitter<AuthState> emit) async {
    emit(AuthState.loading);
    try {
      final session = await _auth.getSession();
      if (session != null) {
        emit(AuthState.authenticated(session));
      } else {
        emit(AuthState.failure('No saved session'));
      }
    } catch (e) {
      emit(AuthState.failure(e.toString()));
    }
  }
}
