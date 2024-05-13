import 'package:ptit_quiz_frontend/data/models/exam_model.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';

class CourseModel extends Course {
  CourseModel({
    required super.id,
    required super.title,
    required super.description,
    required super.credit,
    required super.lecturer,
    required super.department,
    super.status = 'active',
    super.exams,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      credit: json['credits'],
      lecturer: json['lecturer'],
      department: json['department'],
      status: json['status'],
      // exams: (json['exams'] != null)
      //     ? json['exams'].map((e) => ExamModel.fromJson(e)).toList()
      //     : null,
    );
  }

  factory CourseModel.fromJsonCreate(Map<String, dynamic> json) {
    return CourseModel(
      id: json['data']['_id'],
      title: json['data']['title'],
      description: json['data']['description'],
      credit: json['data']['credits'],
      lecturer: json['data']['lecturer'],
      department: json['data']['department'],
      status: json['data']['status'],
      // exams: (json['exams'] != null)
      //     ? json['exams'].map((e) => ExamModel.fromJson(e)).toList()
      //     : null,
    );
  }

  Map<String, dynamic> toJson({status = 'active'}) {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'credits': credit,
      'lecturer': lecturer,
      'department': department,
      'status': status,
      // 'exams' : ExamModel.toJsonList(ExamModel.fromEntityList(exams)),
    };
  }

  Map<String, dynamic> toJsonCreate({status = 'active'}) {
    return {
      'title': title,
      'description': description,
      'credits': credit,
      'lecturer': lecturer,
      'department': department,
      'status': status,
      // 'exams' : ExamModel.toJsonList(ExamModel.fromEntityList(exams)),
    };
  }

  factory CourseModel.fromEntity(Course course) {
    return CourseModel(
      id: course.id,
      title: course.title,
      description: course.description,
      credit: course.credit,
      lecturer: course.lecturer,
      department: course.department,
      status: course.status,
    );
  }
}
