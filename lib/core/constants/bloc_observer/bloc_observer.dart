import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AppBlocObserver extends BlocObserver {
  // @override
  // void onEvent(Bloc bloc, Object? event) {
  //   debugPrint('onEvent:\n      -- bloc:$bloc\n     event: $event');
  //   super.onEvent(bloc, event);
  // }

  // @override
  // void onChange(BlocBase bloc, Change change) {
  //   debugPrint('onChange:\n      -- bloc:$bloc\n     change: $change');
  //   super.onChange(bloc, change);
  // }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    debugPrint(
        'onTransition:\n      -- bloc:$bloc\n     transition: $transition');
    super.onTransition(bloc, transition);
  }

  // @override
  // void onError(BlocBase bloc, Object error, StackTrace stackTrace) {

  //   super.onError(bloc, error, stackTrace);
  // }
}
