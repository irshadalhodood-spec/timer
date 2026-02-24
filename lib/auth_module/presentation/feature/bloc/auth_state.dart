part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];

  static const AuthState initial = AuthStateInitial();
  static const AuthState loading = AuthStateLoading();
  static AuthState authenticated(AuthSessionEntity session) => AuthStateAuthenticated(session);
  static AuthState unauthenticated({bool hasOrgUrl = false}) => AuthStateUnauthenticated(hasOrgUrl: hasOrgUrl);
  static AuthState failure(String message) => AuthStateFailure(message);
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  const AuthStateAuthenticated(this.session);
  final AuthSessionEntity session;
  @override
  List<Object?> get props => [session];
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated({this.hasOrgUrl = false});
  final bool hasOrgUrl;
  @override
  List<Object?> get props => [hasOrgUrl];
}

class AuthStateFailure extends AuthState {
  const AuthStateFailure(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

