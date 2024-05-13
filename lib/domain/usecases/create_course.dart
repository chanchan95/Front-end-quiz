import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/repositories/exam_repository.dart';

class CreateCourse {
  final ExamRepository _examRepository;

  CreateCourse({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<Course> call(Course course) {
    return _examRepository.createCourse(course);
  }
}