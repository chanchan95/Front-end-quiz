import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_admin_statistics.dart';

part 'statistics_event.dart';
part 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  late GetAdminStatistics _getAdminStatistics;

  StatisticsBloc({required GetAdminStatistics getAdminStatistics}) : super(StatisticsInitial()) {
    _getAdminStatistics = getAdminStatistics;
    
    on<GetAdminStatisticsEvent>(_onGetAdminStatistics);

    add(GetAdminStatisticsEvent());
  }

  Future<void> _onGetAdminStatistics(StatisticsEvent event, Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading());
    try {
      final statistics = await _getAdminStatistics();
      emit(StatisticsLoaded(statistics: statistics));
    } catch (e) {
      emit(StatisticsError(message: e.toString()));
    }
  }
}
