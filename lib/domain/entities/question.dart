class Question {
  final String id;
  final String content;
  final List<String> answers;
  final int? correctAnswer;
  final int? userAnswer;

  Question({
    required this.id,
    required this.content,
    required this.answers,
    this.correctAnswer,
    this.userAnswer,
  });

  const Question.empty()
      : id = '',
        content = '',
        answers = const [],
        correctAnswer = 0,
        userAnswer = 0;

  Question copyWith({
    String? id,
    String? content,
    List<String>? answers,
    int? correctAnswer,
    int? userAnswer,
  }) {
    return Question(
      id: id ?? this.id,
      content: content ?? this.content,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      userAnswer: userAnswer ?? this.userAnswer,
    );
  }
}
