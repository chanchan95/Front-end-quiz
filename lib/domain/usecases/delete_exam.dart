import '../repositories/exam_repository.dart';

class DeleteExam {
  final ExamRepository _examRepository;

  DeleteExam({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<void> call(String id) {
    return _examRepository.deleteExam(id);
  }
}