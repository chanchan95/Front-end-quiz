import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ptit_quiz_frontend/domain/entities/result.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_result_long.dart';

part 'long_result_event.dart';
part 'long_result_state.dart';

class LongResultBloc extends Bloc<LongResultEvent, LongResultState> {
  late getResultLong _getResultLong;

  LongResultBloc({required getResultLong getResultLong})
      : super(LongResultLoading()) {
    _getResultLong = getResultLong;

    on<FetchLongResultsEvent>(_onFetchLongResults);

    add(FetchLongResultsEvent());
  }

  Future<void> _onFetchLongResults(
      FetchLongResultsEvent event, Emitter<LongResultState> emit) async {
    emit(LongResultLoading());
    try {
      print('FIRST');
      final List<Result> results = await _getResultLong();
      print('SECOND');
      emit(LongResultLoaded(results: results));
    } catch (e) {
      print('THIRD');
      emit(LongResultError(message: e.toString()));
    }
  }
}
