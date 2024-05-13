import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/core/utils/ticker.dart';

class TimerCubit extends Cubit<int> {
  TimerCubit({required Ticker ticker}) : _ticker = ticker, super(0);

  final Ticker _ticker;
  StreamSubscription<int>? _timerSubscription;

  void start({required int duration}) {
    _timerSubscription?.cancel();
    _timerSubscription = _ticker.tick(ticks: duration).listen((duration) => emit(duration));
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}