import 'package:ptit_quiz_frontend/data/models/course_model.dart';
import 'package:ptit_quiz_frontend/data/models/profile_model.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/entities/profile.dart';
import 'package:ptit_quiz_frontend/domain/entities/question.dart';

import '../models/exam_model.dart';
import '../providers/remote_data.dart';
import '../../domain/entities/exam.dart';
import '../../domain/repositories/exam_repository.dart';

class ExamRepositoryImpl implements ExamRepository {
  final RemoteData remoteData;

  ExamRepositoryImpl({required this.remoteData});

  @override
  Future<Exam> createExam(Exam exam) async {
    return await remoteData.createExam(ExamModel.fromEntity(exam));
  }

  @override
  Future<Exam> updateExam(Exam exam) async {
    return await remoteData.updateExam(ExamModel.fromEntity(exam));
  }

  @override
  Future<Exam> deleteExam(String id) async {
    return await remoteData.deleteExam(id);
  }

  @override
  Future<List<Exam>> getExams(String sortKey, String sortValue) async {
    return await remoteData.getExams(sortKey, sortValue);
  }

  @override
  Future<List<Exam>> getExamsAdmin(String sortKey, String sortValue) async {
    return await remoteData.getExamsAdmin(sortKey, sortValue);
  }

  @override
  Future<Exam> getExam(String id) async {
    return await remoteData.getExam(id);
  }

  @override
  Future<List<Course>> getCourses(String sortKey, String sortValue) async {
    return await remoteData.getCourses(sortKey, sortValue);
  }

  @override
  Future<List<Course>> getCoursesAdmin(String sortKey, String sortValue) async {
    return await remoteData.getCoursesAdmin(sortKey, sortValue);
  }

  @override
  Future<Map<String, dynamic>> submitExam(String id, List<Question> answers) async {
    return await remoteData.submitExam(id, answers);
  }

  @override
  Future<List<Map<String, dynamic>>> getExamResults() async {
    return await remoteData.getExamResults();
  }

  @override
  Future<Map<String, dynamic>> getExamResult(String id) async {
    return await remoteData.getExamResult(id);
  }

  @override
  Future<Course> createCourse(Course course) async {
    return await remoteData.createCourse(CourseModel.fromEntity(course));
  }

  @override
  Future<Profile> createProfile(Profile profile) async {
    return await remoteData.createUser(ProfileModel.fromEntity(profile));
  }

  @override
  Future<List<Profile>> getUserProfiles(String keyWord, String choice) async{
    return await remoteData.getUsers(keyWord, choice);
  }
}