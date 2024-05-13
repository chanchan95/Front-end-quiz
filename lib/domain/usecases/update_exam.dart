import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class UpdateExam {
  final ExamRepository _examRepository;

  UpdateExam({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<Exam> call(Exam exam) {
    return _examRepository.updateExam(exam);
  }
}