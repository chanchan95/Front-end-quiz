import 'package:ptit_quiz_frontend/domain/entities/result.dart';

class ResultModel extends Result {
  ResultModel({
    required super.examId,
    required super.title,
    required super.result,
    required super.timeFinish,
  });

  factory ResultModel.fromJson(Map<String, dynamic> json) {
    return ResultModel(
      examId: json['exam_id'],
      title: json['title'],
      result: json['result'],
      timeFinish: json['timeDoneExam'],
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'exam_id': examId,
      'title': title,
      'result': result,
      'timeFinish': timeFinish,
    };
  }
}
