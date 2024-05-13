import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/entities/profile.dart';
import 'package:ptit_quiz_frontend/domain/repositories/exam_repository.dart';

class CreateUser {
  final ExamRepository _examRepository;

  CreateUser({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<void> call(Profile profile) {
    return _examRepository.createProfile(profile);
  }
}