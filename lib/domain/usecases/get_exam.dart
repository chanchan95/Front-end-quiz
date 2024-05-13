import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class GetExam {
  final ExamRepository _examRepository;

  GetExam({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<Exam> call(String id) {
    return _examRepository.getExam(id);
  }
}