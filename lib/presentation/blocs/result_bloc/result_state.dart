part of 'result_bloc.dart';

sealed class ResultState extends Equatable {
  const ResultState();
  
  @override
  List<Object> get props => [];
}

final class ResultLoading extends ResultState {}

final class ResultLoaded extends ResultState {
  final List<Map<String, dynamic>> results;

  const ResultLoaded({required this.results});

  @override
  List<Object> get props => [results];
}

final class ResultError extends ResultState {
  final String message;

  const ResultError({required this.message});

  @override
  List<Object> get props => [message];
}
