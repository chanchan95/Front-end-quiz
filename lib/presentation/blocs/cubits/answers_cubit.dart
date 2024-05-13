import 'package:flutter_bloc/flutter_bloc.dart';

class AnswersCubit extends Cubit<List<int>> {
  AnswersCubit() : super([]);

  void init(int length) {
    emit(List<int>.generate(length, (index) => -1));
  }

  void setAnswer(int questionIndex, int answerIndex) {
    state[questionIndex] = answerIndex;
    emit(List<int>.from(state));
  }
}