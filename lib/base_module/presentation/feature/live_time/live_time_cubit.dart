import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';


class LiveTimeCubit extends Cubit<DateTime> {
  LiveTimeCubit() : super(DateTime.now()) {
    _start();
  }

  Timer? _timer;

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isClosed) emit(DateTime.now());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _timer = null;
    return super.close();
  }
}
