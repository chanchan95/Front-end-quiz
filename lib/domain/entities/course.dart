import 'package:ptit_quiz_frontend/domain/entities/exam.dart';

class Course {
  final String? id;
  final String title;
  final String description;
  final int credit;
  final String lecturer;
  final String department;
  final String status;
  List<Exam>? exams;

  Course({
    this.id,
    required this.title,
    required this.description,
    required this.credit,
    required this.lecturer,
    required this.department,
    this.status = 'active',
    this.exams,
  });

  Course.empty()
      : id = '',
        title = '',
        description = '',
        credit = 0,
        lecturer = '',
        department = '',
        status = 'active',
        exams = null;

  Course copyWith({
    String? id,
    String? title,
    String? description,
    int? credit,
    String? lecturer,
    String? department,
    String? status,
    List<Exam>? exams,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      credit: credit ?? this.credit,
      lecturer: lecturer ?? this.lecturer,
      department: department ?? this.department,
      status: status ?? this.status,
      exams: exams ?? this.exams,
    );
  }

  // copy with a list of courses
  

}
