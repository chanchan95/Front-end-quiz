part of 'result_detail_bloc.dart';

sealed class ResultDetailState extends Equatable {
  const ResultDetailState();
  
  @override
  List<Object> get props => [];
}

final class ResultDetailInitial extends ResultDetailState {}

final class ResultDetailLoading extends ResultDetailState {}

final class ResultDetailLoaded extends ResultDetailState {
  final Map<String, dynamic> result;

  const ResultDetailLoaded({required this.result});

  @override
  List<Object> get props => [result];
}

final class ResultDetailError extends ResultDetailState {
  final String message;

  const ResultDetailError({required this.message});

  @override
  List<Object> get props => [message];
}
