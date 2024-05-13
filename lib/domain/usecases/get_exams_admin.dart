import 'package:ptit_quiz_frontend/domain/entities/exam.dart';
import 'package:ptit_quiz_frontend/domain/repositories/exam_repository.dart';

class GetExamsAdmin{
  final ExamRepository _examRepository;

  GetExamsAdmin({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<List<Exam>> call(String sortKey, String sortValue) {
    return _examRepository.getExamsAdmin(sortKey, sortValue);
  }
}