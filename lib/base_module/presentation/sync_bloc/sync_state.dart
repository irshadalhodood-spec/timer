part of 'sync_bloc.dart';

abstract class SyncState extends Equatable {
  const SyncState();
  @override
  List<Object?> get props => [];

  static const SyncState initial = SyncStateInitial();
  static const SyncState syncing = SyncStateSyncing();
  static SyncState synced({required int synced, required int total}) =>
      SyncStateSynced(synced: synced, total: total);
  static SyncState failed({required String error}) => SyncStateFailed(error: error);
  static SyncState pendingCount(int count) => SyncStatePendingCount(count);
}

class SyncStateInitial extends SyncState {
  const SyncStateInitial();
}

class SyncStateSyncing extends SyncState {
  const SyncStateSyncing();
}

class SyncStateSynced extends SyncState {
  const SyncStateSynced({required this.synced, required this.total});
  final int synced;
  final int total;
  @override
  List<Object?> get props => [synced, total];
}

class SyncStateFailed extends SyncState {
  const SyncStateFailed({required this.error});
  final String error;
  @override
  List<Object?> get props => [error];
}

class SyncStatePendingCount extends SyncState {
  const SyncStatePendingCount(this.count);
  final int count;
  @override
  List<Object?> get props => [count];
}
