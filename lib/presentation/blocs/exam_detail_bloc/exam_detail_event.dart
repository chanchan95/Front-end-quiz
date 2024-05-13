part of 'exam_detail_bloc.dart';

sealed class ExamDetailEvent extends Equatable {
  const ExamDetailEvent();

  @override
  List<Object> get props => [];
}

final class ExamDetailInitialEvent extends ExamDetailEvent {}

final class ExamDetailGetEvent extends ExamDetailEvent {
  final String examId;

  const ExamDetailGetEvent({
    required this.examId,
  });

  @override
  List<Object> get props => [examId];
}

final class ExamDetailSubmitEvent extends ExamDetailEvent {
  final String examId;
  final Exam exam;
  final List<int> answers;

  const ExamDetailSubmitEvent({
    required this.exam,
    required this.examId,
    required this.answers,
  });

  @override
  List<Object> get props => [examId, answers];
}
