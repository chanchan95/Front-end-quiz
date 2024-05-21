import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_exams_admin.dart';

import '../../../domain/entities/exam.dart';
import '../../../domain/usecases/create_exam.dart';
import '../../../domain/usecases/delete_exam.dart';
import '../../../domain/usecases/update_exam.dart';
import '../../../domain/usecases/get_exams.dart';
import '../../../domain/usecases/get_exam.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  late CreateExam _createExam;
  late UpdateExam _updateExam;
  late DeleteExam _deleteExam;
  late GetExams _getExams;
  late GetExamsAdmin _getExamsAdmin;
  late GetExam _getExam;

  ExamBloc({
    required CreateExam createExam,
    required UpdateExam updateExam,
    required DeleteExam deleteExam,
    required GetExams getExams,
    required GetExamsAdmin getExamsAdmin,
    required GetExam getExam,
  }) : super(const ExamState()) {
    _createExam = createExam;
    _updateExam = updateExam;
    _deleteExam = deleteExam;
    _getExams = getExams;
    _getExamsAdmin = getExamsAdmin;
    _getExam = getExam;

    on<FetchExamsEvent>(_onFetchExams);
    on<FetchExamsAdminEvent>(_onFetchExamsAdmin);
    on<CreateExamEvent>(_onCreateExam);
    on<UpdateExamEvent>(_onUpdateExam);
    on<DeleteExamEvent>(_onDeleteExam);
    on<FetchExamEvent>(_onFetchExam);

    // add(const FetchExamsEvent());
  }

  Future<void> _onFetchExams(
      FetchExamsEvent event, Emitter<ExamState> emit) async {
    emit(const ExamStateLoading());
    try {
      final exams = await _getExams(event.sortKey, event.sortValue);
      emit(ExamStateListLoaded(exams: exams));
    } catch (e) {
      emit(ExamStateError(message: e.toString()));
    }
  }

  Future<void> _onCreateExam(
      CreateExamEvent event, Emitter<ExamState> emit) async {
    emit(const ExamStateLoading());
    try {
      final response = await _createExam(event.exam);
      emit(ExamStateCreated(exam: response));
    } catch (e) {
      // emit(ExamStateError(message: e.toString()));
    }
  }

  Future<void> _onUpdateExam(
      UpdateExamEvent event, Emitter<ExamState> emit) async {
    emit(const ExamStateLoading());
    try {
      final response = await _updateExam(event.exam);
      emit(ExamStateUpdated(exam: response));
    } catch (e) {
      emit(ExamStateError(message: e.toString()));
    }
  }

  Future<void> _onDeleteExam(
      DeleteExamEvent event, Emitter<ExamState> emit) async {
    emit(const ExamStateLoading());
    try {
      await _deleteExam(event.id);
      emit(const ExamStateDeleted());
    } catch (e) {
      emit(ExamStateError(message: e.toString()));
    }
  }

  Future<void> _onFetchExam(
      FetchExamEvent event, Emitter<ExamState> emit) async {
    emit(const ExamStateLoading());
    try {
      final response = await _getExam(event.id);
      print(response.questions);
      emit(ExamStateLoaded(exam: response));
    } catch (e) {
      emit(ExamStateError(message: e.toString()));
    }
  }

  Future<void> _onFetchExamsAdmin(
      FetchExamsAdminEvent event, Emitter<ExamState> emit) async {
    emit(const ExamStateLoading());
    try {
      final exams = await _getExamsAdmin(event.sortKey, event.sortValue);
      emit(ExamStateListLoaded(exams: exams));
    } catch (e) {
      emit(ExamStateError(message: e.toString()));
    }
  }
}
