import 'package:ptit_quiz_frontend/data/models/question_model.dart';

import '../../domain/entities/exam.dart';

class ExamModel extends Exam {
  ExamModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.totalPoint,
    super.timeStart,
    super.timeFinish,
    required super.courseId,
    super.status,
    super.questions,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      totalPoint: json['totalPoint'],
      timeStart: json['timeStart'] ?? null,
      timeFinish: json['timeFinish'] ?? null,
      courseId: json['course_id'],
      status: json['status'] ?? 'active',
      questions: (json['questions'] != null)
          ? QuestionModel.fromJsonList(json['questions'])
          : null,
    );
  }

  factory ExamModel.fromJsondetail(Map<String, dynamic> json) {
    return ExamModel(
      id: json['record']['_id'],
      title: json['record']['title'],
      description: json['record']['description'],
      type: json['record']['type'],
      totalPoint: json['record']['totalPoint'],
      timeStart: json['record']['timeStart'] ?? null,
      timeFinish: json['record']['timeFinish'] ?? null,
      courseId: json['record']['course_id'],
      status: json['record']['status'] ?? 'active',
      questions: (json['questions'] != null)
          ? QuestionModel.fromJsonList(json['questions'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'record': {
        'title': title,
        'description': description,
        'type': type,
        'totalPoint': totalPoint,
        'course_id': courseId,
        'status': status,
      },
      'questions':
            QuestionModel.toJsonList(QuestionModel.fromEntityList(questions))
              
    };
  }


  factory ExamModel.fromEntity(Exam exam) {
    return ExamModel(
      id: exam.id,
      title: exam.title,
      description: exam.description,
      type: exam.type,
      totalPoint: exam.totalPoint,
      timeStart: exam.timeStart ?? null,
      timeFinish: exam.timeFinish ?? null,
      courseId: exam.courseId,
      status: exam.status,
      questions: exam.questions,
    );
  }
}

// import 'package:ptit_quiz_frontend/data/models/question_model.dart';

// import '../../domain/entities/exam.dart';

// class ExamModel extends Exam {
//   ExamModel({
//     required super.id,
//     required super.name,
//     required super.duration,
//     required super.start,
//     super.questions,
//   });

//   factory ExamModel.fromJson(Map<String, dynamic> json) {
//     return ExamModel(
//       id: json['id'],
//       name: json['name'],
//       duration: json['duration'],
//       start: json['start'] ?? '',
//       questions: (json['questions'] != null)
//           ? QuestionModel.fromJsonList(json['questions'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'duration': duration,
//       'start': start,
//       'questions':
//           QuestionModel.toJsonList(QuestionModel.fromEntityList(questions)),
//     };
//   }

//   factory ExamModel.fromEntity(Exam exam) {
//     return ExamModel(
//       id: exam.id,
//       name: exam.name,
//       duration: exam.duration,
//       start: exam.start,
//     );
//   }
// }
