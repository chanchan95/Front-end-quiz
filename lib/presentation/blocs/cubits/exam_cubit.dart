import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/domain/entities/exam.dart';
import '../../../domain/entities/question.dart';

class ExamCubit extends Cubit<Exam> {
  ExamCubit() : super(const Exam.empty());

  void setExam(Exam exam) => emit(exam);

  void setName(String name) {
    final exam = state.copyWith(title: name);
    emit(exam);
  }

  void setDescription(String description) {
    final exam = state.copyWith(description: description);
    emit(exam);
  }

  void setDuration(int duration) {
    final exam = state.copyWith(duration: duration);
    emit(exam);
  }

  void setType(String type) {
    final exam = state.copyWith(type: type);
    emit(exam);
  }

  void setCourseId(String courseId) {
    final exam = state.copyWith(courseId: courseId);
    emit(exam);
  }

  void setStatus(String status) {
    final exam = state.copyWith(status: status);
    emit(exam);
  }

  void setTotalPoint(int totalPoint) {
    final exam = state.copyWith(totalPoint: totalPoint);
    emit(exam);
  }

  void setStart(String start) {
    final exam = state.copyWith(timeStart: start);
    emit(exam);
  }

  void setQuestions(List<Question> questions) {
    final exam = state.copyWith(questions: questions);
    emit(exam);
  }

  void addQuestion(Question question) {
    final questions = state.questions ?? <Question>[];
    questions.add(question);
    final exam = state.copyWith(questions: questions);
    emit(exam);
  }

  void updateQuestion(Question question, int index) {
    final questions = state.questions ?? <Question>[];
    questions[index] = question;
    final exam = state.copyWith(questions: questions);
    emit(exam);
  }

  void removeQuestion(int index) {
    final questions = state.questions ?? <Question>[];
    questions.removeAt(index);
    final exam = state.copyWith(questions: questions);
    emit(exam);
  }

  void clear() => emit(const Exam.empty());
}
