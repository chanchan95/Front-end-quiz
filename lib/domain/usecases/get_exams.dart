import '../entities/exam.dart';
import '../repositories/exam_repository.dart';

class GetExams {
  final ExamRepository _examRepository;

  GetExams({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<List<Exam>> call(String sortKey, String sortValue) {
    return _examRepository.getExams(sortKey, sortValue);
  }
}