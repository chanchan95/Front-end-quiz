import 'package:ptit_quiz_frontend/domain/repositories/exam_repository.dart';

class GetExamResult {
  final ExamRepository _examRepository;

  GetExamResult({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<Map<String, dynamic>> call(String id) {
    return _examRepository.getExamResult(id);
  }
}