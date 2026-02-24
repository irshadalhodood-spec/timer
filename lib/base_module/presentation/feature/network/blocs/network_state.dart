part of 'network_bloc.dart';

enum NetworkStatus { online, offline }

class NetworkState extends Equatable {
  final NetworkStatus status;

  const NetworkState._({required this.status});

  const NetworkState.online() : this._(status: NetworkStatus.online);
  const NetworkState.offline() : this._(status: NetworkStatus.offline);

  @override
  List<Object?> get props => [status];
}

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object?> get props => [];
}