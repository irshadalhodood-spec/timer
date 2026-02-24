import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import '../../../../domain/entities/network.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final Connectivity _connectivity;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  NetworkBloc({Connectivity? connectivity}) 
      : _connectivity = connectivity ?? Connectivity(),
        super(const NetworkState.online()) {
    on<CheckNetwork>(_onCheckNetwork);
    on<SwitchNetwork>(_onSwitchNetwork);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);
  }

  Future<void> _onCheckNetwork(CheckNetwork event, Emitter<NetworkState> emit) async {
    final isOnline = await network.isOnline;
    emit(isOnline ? const NetworkState.online() : const NetworkState.offline());
  }

  void _onSwitchNetwork(SwitchNetwork event, Emitter<NetworkState> emit) {
    emit(event.isOnline ? const NetworkState.online() : const NetworkState.offline());
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> result) async {
    final isOnline = await network.isOnline;
    add(SwitchNetwork(isOnline: isOnline));
  }

  @override
  Future<void> close() {
    _connectivitySubscription.cancel();
    return super.close();
  }
}