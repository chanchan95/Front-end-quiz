import 'package:bloc/bloc.dart';
import 'package:ptit_quiz_frontend/domain/entities/question.dart';

class ListQuestionCubit extends Cubit<List<Question>> {
  ListQuestionCubit() : super([]);


  void setQuestions(List<Question> questions) => emit(questions);

  void addQuestion(Question question) {
    final List<Question> currentState = state;
    currentState.add(question);
    emit(currentState);
  }
  // empty list
  void clearQuestions() => emit([]);
}