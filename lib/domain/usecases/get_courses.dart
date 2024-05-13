import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/repositories/exam_repository.dart';

class getCourses{
  final ExamRepository _examRepository;

  getCourses({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<List<Course>> call(String sortKey, String sortValue) {
    return _examRepository.getCourses(sortKey, sortValue);
  }
}