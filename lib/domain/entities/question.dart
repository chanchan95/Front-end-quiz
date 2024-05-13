class Question {
  final String id;
  final String content;
  final List<String> answers;
  final int? correctAnswer;
  final int? userAnswer;
  final String? explaination;

  Question({
    required this.id,
    required this.content,
    required this.answers,
    this.correctAnswer,
    this.userAnswer,
    this.explaination,
  });
 

   Question.empty()
      : id = '',
        content = '',
        answers = List.empty(),
        correctAnswer = 0,
        userAnswer = 0,
        explaination = '';

  Question copyWith({
    String? id,
    String? content,
    List<String>? answers,
    int? correctAnswer,
    int? userAnswer,
    String? explaination,
  }) {
    return Question(
      id: id ?? this.id,
      content: content ?? this.content,
      answers: answers ?? this.answers,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      userAnswer: userAnswer ?? this.userAnswer,
      explaination: explaination ?? this.explaination,
    );
  }
}
