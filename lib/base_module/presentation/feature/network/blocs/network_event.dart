 part of 'network_bloc.dart';

class CheckNetwork extends NetworkEvent {}

class SwitchNetwork extends NetworkEvent {
  final bool isOnline;

  const SwitchNetwork({required this.isOnline});

  @override
  List<Object?> get props => [isOnline];
}