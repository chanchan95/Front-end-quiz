
import '../repositories/exam_repository.dart';

class GetAdminStatistics {
  final ExamRepository _examRepository;

  GetAdminStatistics({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<Map<String, dynamic>> call() {
    return _examRepository.getAdminStatistics();
  }
}