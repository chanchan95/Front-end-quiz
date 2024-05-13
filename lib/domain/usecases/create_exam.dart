import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class CreateExam {
  final ExamRepository _examRepository;

  CreateExam({required ExamRepository examRepository})
      : _examRepository = examRepository;

  Future<Exam> call(Exam exam) {
    return _examRepository.createExam(exam);
  }
}
