import 'package:ptit_quiz_frontend/domain/entities/exam.dart';
import 'package:ptit_quiz_frontend/domain/entities/result.dart';
import 'package:ptit_quiz_frontend/domain/repositories/exam_repository.dart';

class getResultLong{
  final ExamRepository _examRepository;
  getResultLong({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<List<Result>> call() {
    return _examRepository.getResults();
  }
}