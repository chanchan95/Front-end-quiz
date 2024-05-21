part of 'long_result_bloc.dart';

class LongResultState extends Equatable {
  const LongResultState();
  
  @override
  List<Object> get props => [];
}

class LongResultLoading extends LongResultState {
  const LongResultLoading();
  
  @override
  List<Object> get props => [];
}

class LongResultLoaded extends LongResultState {
  final List<Result> results;

  const LongResultLoaded({required this.results});

  @override
  List<Object> get props => [results];
}

class LongResultError extends LongResultState {
  final String message;

  const LongResultError({required this.message});

  @override
  List<Object> get props => [message];
}