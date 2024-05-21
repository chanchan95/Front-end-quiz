import 'question.dart';
import 'course.dart';
class Exam {
  final String id;
  final String title;
  final String description;
  final String type;
  final int totalPoint;
  final int duration;
  final String? timeStart;
  final String? timeFinish;
  final String courseId;
  final String status;
  
  // final int 

  final List<Question>? questions;

  Exam({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.totalPoint,
    this.duration = 60,
    this.timeStart,
    this.timeFinish,
    required this.courseId,
    this.status = 'active',
    this.questions,
  });

  const Exam.empty()
      : id = '',
        title = '',
        description = '',
        type = '',
        totalPoint = 0,
        duration = 0,
        timeStart = '',
        timeFinish = '',
        courseId = '',
        status = 'active',
        questions = null;

  Exam copyWith({
    String? id,
    String? title,
    String? description,
    String? type,
    int? totalPoint,
    int? duration,
    String? timeStart,
    String? timeFinish,
    String? courseId,
    String? status,
    List<Question>? questions,
  }) {
    return Exam(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      totalPoint: totalPoint ?? this.totalPoint,
      duration: duration ?? this.duration,
      timeStart: timeStart ?? this.timeStart,
      timeFinish: timeFinish ?? this.timeFinish,
      courseId: courseId ?? this.courseId,
      status: status ?? this.status,
      questions: questions ?? this.questions,
    );
  }
}

// import 'question.dart';

// class Exam {
//   final String id;
//   final String name;
//   final int duration;
//   final int? start;
//   final List<Question>? questions;

//   Exam({
//     required this.id,
//     required this.name,
//     required this.duration,
//     required this.start,
//     this.questions,
//   });

//   const Exam.empty()
//       : id = '',
//         name = '',
//         duration = 0,
//         start = 0,
//         questions = null;

//   Exam copyWith({
//     String? id,
//     String? name,
//     int? duration,
//     int? start,
//     List<Question>? questions,
//   }) {
//     return Exam(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       duration: duration ?? this.duration,
//       start: start ?? this.start,
//       questions: questions ?? this.questions,
//     );
//   }
// }
