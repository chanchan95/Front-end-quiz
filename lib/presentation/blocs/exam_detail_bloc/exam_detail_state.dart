part of 'exam_detail_bloc.dart';

sealed class ExamDetailState extends Equatable {
  const ExamDetailState();
  
  @override
  List<Object> get props => [];
}

final class ExamDetailInitial extends ExamDetailState {}

final class ExamDetailLoading extends ExamDetailState {}

final class ExamDetailLoaded extends ExamDetailState {
  final Exam exam;

  const ExamDetailLoaded({
    required this.exam,
  });

  @override
  List<Object> get props => [exam];
}

final class ExamDetailSubmitted extends ExamDetailState {
  final Map<String, dynamic> result;

  const ExamDetailSubmitted({
    required this.result,
  });

  @override
  List<Object> get props => [result];
}

final class ExamDetailError extends ExamDetailState {
  final String message;

  const ExamDetailError({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
