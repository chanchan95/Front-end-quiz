import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/entities/profile.dart';
import 'package:ptit_quiz_frontend/domain/entities/question.dart';
import 'package:ptit_quiz_frontend/domain/entities/result.dart';

import '../entities/exam.dart';

abstract class ExamRepository {
  Future<Exam> createExam(Exam exam);
  Future<Exam> updateExam(Exam exam);
  Future<Exam> deleteExam(String id);
  Future<List<Exam>> getExams(String sortKey, String sortValue);
  Future<List<Result>> getResults();
  Future<List<Exam>> getExamsAdmin(String sortKey, String sortValue);
  Future<Exam> getExam(String id);
  // Future<Course> getCourse(String sortKey, String sortValue);  
  Future<Course> createCourse(Course course);
  Future<List<Course>> getCourses(String sortKey, String sortValue);
  Future<List<Course>> getCoursesAdmin(String sortKey, String sortValue);
  Future<Map<String, dynamic>> submitExam(String id, List<Question> questions);
  Future<List<Map<String, dynamic>>> getExamResults();
  Future<Map<String, dynamic>> getExamResult(String id);
  Future<List<Profile>> getUserProfiles(String keyWord, String choice);
  Future<Profile> createProfile(Profile profile);
  Future<Map<String, dynamic>> getAdminStatistics();
}