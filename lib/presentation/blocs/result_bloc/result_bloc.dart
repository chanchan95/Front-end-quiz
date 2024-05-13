import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_exam_results.dart';

part 'result_event.dart';
part 'result_state.dart';

class ResultBloc extends Bloc<ResultEvent, ResultState> {
  late GetExamResults _getExamResults;

  ResultBloc({required GetExamResults getExamResults}) : super(ResultLoading()) {
    _getExamResults = getExamResults;
    
    on<GetResultsEvent>(_onGetExamResults);

    add(GetResultsEvent());
  }

  Future<void> _onGetExamResults(GetResultsEvent event, Emitter<ResultState> emit) async {
    emit(ResultLoading());
    try {
      final results = await _getExamResults();
      emit(ResultLoaded(results: results));
    } catch (e) {
      emit(ResultError(message: e.toString()));
    }
  }
}
