part of 'result_detail_bloc.dart';

sealed class ResultDetailEvent extends Equatable {
  const ResultDetailEvent();

  @override
  List<Object> get props => [];
}

final class ResultDetailInitialEvent extends ResultDetailEvent {}

final class GetResultDetailEvent extends ResultDetailEvent {
  final String resultId;

  const GetResultDetailEvent({required this.resultId});

  @override
  List<Object> get props => [resultId];
}
