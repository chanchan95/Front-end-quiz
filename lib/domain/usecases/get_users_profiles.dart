import 'package:ptit_quiz_frontend/domain/entities/profile.dart';
import 'package:ptit_quiz_frontend/domain/repositories/exam_repository.dart';

class getUsersProfiles{
  final ExamRepository _examRepository;

  getUsersProfiles({required ExamRepository examRepository}) : _examRepository = examRepository;

  Future<List<Profile>> call(String keyWord, String choice){
    return _examRepository.getUserProfiles(keyWord, choice);
  }
}