part of 'statistics_bloc.dart';

sealed class StatisticsEvent extends Equatable {
  const StatisticsEvent();

  @override
  List<Object> get props => [];
}

final class GetAdminStatisticsEvent extends StatisticsEvent {}
