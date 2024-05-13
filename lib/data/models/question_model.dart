import '../../domain/entities/question.dart';

class QuestionModel extends Question {
  QuestionModel({
    required super.id,
    required super.content,
    required super.answers,
    super.correctAnswer,
    super.userAnswer,
  });

  factory QuestionModel.fromEntity(Question question) {
    return QuestionModel(
      id: question.id,
      content: question.content,
      answers: question.answers,
      correctAnswer: question.correctAnswer,
      userAnswer: question.userAnswer,
    );
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'],
      content: json['description'],
      answers: List<String>.from(json['options']),
      correctAnswer: json['rightAnswer'],
      userAnswer: json['user_option'],
    );
  }

  static List<QuestionModel>? fromJsonList(List<dynamic> json) {
    return json.map((question) => QuestionModel.fromJson(question)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': id,
      'description': content,
      'options': answers,
      'rightAnswer': correctAnswer,
      'user_option': userAnswer,
    };
  }

  static List<Map<String, dynamic>> fromListQuestionToJson(List<QuestionModel> questions) {
    return questions.map((question) => {
      'question_id': question.id,
      'user_option': question.userAnswer,
    }).toList();
  }

  static List<Map<String, dynamic>>? toJsonList(
      List<QuestionModel>? questions) {
    return questions?.map((question) => question.toJson()).toList();
  }

  static List<Question> toEntityList(List<QuestionModel> questions) {
    return questions.map((question) => question).toList();
  }

  static List<QuestionModel>? fromEntityList(List<Question>? questions) {
    return questions
        ?.map((question) => QuestionModel.fromEntity(question))
        .toList();
  }
}
