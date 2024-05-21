part of 'long_result_bloc.dart';

abstract class LongResultEvent extends Equatable {
  const LongResultEvent();

}

class FetchLongResultsEvent extends LongResultEvent {
  const FetchLongResultsEvent();
  @override
  List<Object> get props => [];
}
