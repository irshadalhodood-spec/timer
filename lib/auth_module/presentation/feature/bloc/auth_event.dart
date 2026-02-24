part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.username, required this.password});
  final String username;
  final String password;
  @override
  List<Object?> get props => [username, password];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthOrganizationUrlSubmitted extends AuthEvent {
  const AuthOrganizationUrlSubmitted({required this.url});
  final String url;
  @override
  List<Object?> get props => [url];
}

class AuthBiometricRequested extends AuthEvent {
  const AuthBiometricRequested();
}
