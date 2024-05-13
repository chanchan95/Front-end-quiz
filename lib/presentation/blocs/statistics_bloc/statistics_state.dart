part of 'statistics_bloc.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();
  
  @override
  List<Object> get props => [];
}

final class StatisticsInitial extends StatisticsState {}

final class StatisticsLoading extends StatisticsState {}

final class StatisticsLoaded extends StatisticsState {
  final Map<String, dynamic> statistics;

  const StatisticsLoaded({required this.statistics});

  @override
  List<Object> get props => [statistics];
}

final class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError({required this.message});

  @override
  List<Object> get props => [message];
}