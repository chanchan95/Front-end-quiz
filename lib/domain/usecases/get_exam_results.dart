import '../repositories/exam_repository.dart';

class GetExamResults {
  final ExamRepository _examRepository;

  GetExamResults({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<List<Map<String, dynamic>>> call() {
    return _examRepository.getExamResults();
  }
}