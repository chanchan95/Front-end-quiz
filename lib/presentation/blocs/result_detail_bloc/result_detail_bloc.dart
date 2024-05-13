import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_exam_result.dart';

part 'result_detail_event.dart';
part 'result_detail_state.dart';

class ResultDetailBloc extends Bloc<ResultDetailEvent, ResultDetailState> {
  late GetExamResult _getExamResult;

  ResultDetailBloc({required GetExamResult getExamResult}) : super(ResultDetailInitial()) {
    _getExamResult = getExamResult;

    on<ResultDetailInitialEvent>(_onInitial);
    on<GetResultDetailEvent>(_onGetExamResult);
  }

  Future<void> _onInitial(ResultDetailInitialEvent event, Emitter<ResultDetailState> emit) async {
    emit(ResultDetailInitial());
  }

  Future<void> _onGetExamResult(GetResultDetailEvent event, Emitter<ResultDetailState> emit) async {
    emit(ResultDetailLoading());
    try {
      final result = await _getExamResult(event.resultId);
      emit(ResultDetailLoaded(result: result));
    } catch (e) {
      emit(ResultDetailError(message: e.toString()));
    }
  }
}
