import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ptit_quiz_frontend/data/models/course_model.dart';
import 'package:ptit_quiz_frontend/data/models/question_model.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/entities/question.dart';
import '../models/account_model.dart';
import '../models/exam_model.dart';
import '../models/profile_model.dart';
import '../../domain/entities/exam.dart';

abstract class RemoteData {
  // User Auth
  Future<Map<String, dynamic>> login(AccountModel user);
  Future<Map<String, dynamic>> register(
      AccountModel user, ProfileModel profile);
  Future<Map<String, dynamic>> validate();
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<Map<String, dynamic>> otpPassword(String email, String otp);
  Future<Map<String, dynamic>> resetPassword(String password, String tokenUser);

  // Admin Auth
  Future<Map<String, dynamic>> adminLogin(AccountModel user);
  Future<Map<String, dynamic>> validateAdmin();
  Future<Map<String, dynamic>> refreshTokenAdmin(String refreshToken);
  Future<List<ProfileModel>> getUsers(String keyWord, String choice);
  Future<ProfileModel> createUser(ProfileModel user);
  // Future<ProfileModel> updateUser(ProfileModel user);

  // Exam
  Future<Exam> createExam(ExamModel exam);
  Future<Exam> updateExam(ExamModel exam);
  Future<Exam> deleteExam(String id);
  Future<List<ExamModel>> getExams(String sortKey, String sortValue);
  Future<List<ExamModel>> getExamsAdmin(String sortKey, String sortValue);
  Future<Exam> getExam(String id);

  Future<Course> createCourse(CourseModel course);
  Future<List<CourseModel>> getCourses(String sortKey, String sortValue);
  Future<List<CourseModel>> getCoursesAdmin(String sortKey, String sortValue);
  // Future<Course> getCourse();
  Future<Map<String, dynamic>> submitExam(String id, List<Question> answers);
  Future<List<Map<String, dynamic>>> getExamResults();
  Future<Map<String, dynamic>> getExamResult(String id);
  Future<Map<String, dynamic>> getAdminStatistics();

  // Admin Exam
}

class RemoteDataImpl implements RemoteData {
  final Dio dio;

  RemoteDataImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> login(AccountModel user) async {
    final response = await dio.post("/api/v1/users/login", data: user.toJson());
    switch (response.statusCode) {
      case 200:
        return {
          "access_token": response.data["tokenUser"],
          // "refresh_token": response.data["refresh_token"],
        };
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> adminLogin(AccountModel user) async {
    final response =
        await dio.post("/api/v1/admin/auth/login", data: user.toJson());
    switch (response.statusCode) {
      case 200:
        return {
          "access_token": response.data["token"],
          // "refresh_token": response.data["refresh_token"],
        };
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      AccountModel user, ProfileModel profile) async {
    final response = await dio.post(
      "/api/v1/users/register",
      data: {
        "email": user.email,
        "password": user.password,
        "fullName": profile.fullName,
        "student_code": profile.studentCode,
        "student_class": profile.studentClass,
        "address": profile.address,
        "dob": profile.dob,
      },
    );
    switch (response.statusCode) {
      // case 200:
      case 200:
        return {
          "access_token": response.data["data"]["tokenUser"],
          // "refresh_token": response.data["refresh_token"],
        };
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> validate() async {
    final response = await dio.get("/api/v1/users/val");
    switch (response.statusCode) {
      case 200:
        return {"id": response.data["_id"]};
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> validateAdmin() async {
    final response = await dio.get("/admin/auth/validate");
    switch (response.statusCode) {
      case 200:
        return {"id": response.data["_id"]};
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    dio.options.headers["refresh_token"] = refreshToken;
    final response = await dio.get("/auth/refresh_token");
    switch (response.statusCode) {
      case 200:
        return {
          "access_token": response.data["access_token"],
          "refresh_token": response.data["refresh_token"],
        };
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> refreshTokenAdmin(String refreshToken) async {
    dio.options.headers["refresh_token"] = refreshToken;
    final response = await dio.get("/admin/auth/refresh_token");
    switch (response.statusCode) {
      case 200:
        return {
          "access_token": response.data["access_token"],
          "refresh_token": response.data["refresh_token"],
        };
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<ExamModel> createExam(ExamModel exam) async {
    final response = await dio.post("/admin/exams", data: exam.toJson());
    switch (response.statusCode) {
      case 201:
        return ExamModel.fromJson(response.data);
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<ExamModel> updateExam(ExamModel exam) async {
    final response =
        await dio.put("/admin/exams/${exam.id}", data: exam.toJson());
    switch (response.statusCode) {
      case 200:
        return ExamModel.fromJson(response.data);
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<ExamModel> deleteExam(String id) async {
    final response = await dio.delete("/admin/exams/$id");
    switch (response.statusCode) {
      case 204:
        return ExamModel.fromJson(response.data);
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<List<ExamModel>> getExams(String sortKey, String sortValue) async {
    final response = await dio
        .get("/api/v1/exams?limit=99&sortKey=$sortKey&sortValue=$sortValue");
    switch (response.statusCode) {
      case 200:
        return (response.data as List)
            .map((e) => ExamModel.fromJson(e))
            .toList();
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<List<ExamModel>> getExamsAdmin(
      String sortKey, String sortValue) async {
    final response = await dio.get(
        "/api/v1/admin/exams?limit=99&sortKey=$sortKey&sortValue=$sortValue");
    switch (response.statusCode) {
      case 200:
        return (response.data as List)
            .map((e) => ExamModel.fromJson(e))
            .toList();
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<ExamModel> getExam(String id) async {
    final response = await dio.get("/api/v1/exams/detail/$id");
    switch (response.statusCode) {
      case 200:
        return ExamModel.fromJsondetail(response.data);

      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<List<ProfileModel>> getUsers(String keyWord, String choice) async {
    final response = await dio
        .get("/api/v1/admin/users?keyword=$keyWord&choice=$choice&limit=99");
    switch (response.statusCode) {
      case 200:
        return (response.data as List)
            .map((e) => ProfileModel.fromJson(e))
            .toList();
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<List<CourseModel>> getCourses(String sortKey, String sortValue) async {
    final response = await dio
        .get("/api/v1/courses?sortKey=$sortKey&sortValue=$sortValue&limit=99");
    switch (response.statusCode) {
      case 200:
        return (response.data as List)
            .map((e) => CourseModel.fromJson(e))
            .toList();
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<List<CourseModel>> getCoursesAdmin(
      String sortKey, String sortValue) async {
    final response = await dio.get(
        "/api/v1/admin/courses?sortKey=$sortKey&sortValue=$sortValue&limit=99");
    switch (response.statusCode) {
      case 200:
        // return response.data;
        return (response.data as List)
            .map((e) => CourseModel.fromJson(e))
            .toList();
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> submitExam(
      String id, List<Question> answers) async {
    // var data = QuestionModel.fromListQuestionToJson(answers)
    final response = await dio.post("/api/v1/exams/detail/$id/result",
        data: QuestionModel.fromListQuestionToJson(
            QuestionModel.fromEntityList(answers)!));
    switch (response.statusCode) {
      case 200:
        return response.data;
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getExamResults() async {
    final response = await dio.get("/exams/results");
    switch (response.statusCode) {
      case 200:
        return (response.data["examResults"] as List)
            .cast<Map<String, dynamic>>();
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> getExamResult(String id) async {
    final response = await dio.get("/exams/results/$id");
    switch (response.statusCode) {
      case 200:
        return response.data;
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response =
        await dio.post("/api/v1/users/password/forgot", data: {"email": email});
    switch (response.statusCode) {
      case 200:
        return {"message": response.data["message"]};
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> otpPassword(String email, String otp) async {
    final response = await dio
        .post("/api/v1/users/password/otp", data: {"email": email, "otp": otp});
    switch (response.statusCode) {
      case 200:
        return {
          // "message": response.data["message"],
          "access_token": response.data["tokenUser"],
        };

      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      String password, String tokenUser) async {
    final response = await dio.post(
      "/api/v1/users/password/reset",
      data: {"password": password, "tokenUser": tokenUser},
    );
    switch (response.statusCode) {
      case 200:
        return {"message": response.data["message"]};
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<Course> createCourse(CourseModel course) async {
    final response = await dio.post("/api/v1/admin/courses/create",
        data: course.toJsonCreate());
    switch (response.statusCode) {
      case 200:
        return CourseModel.fromJsonCreate(response.data);
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }

  @override
  Future<ProfileModel> createUser(ProfileModel user) async {
    final response =
        await dio.post("/api/v1/admin/users/create", data: user.toJsonCreate());
    switch (response.statusCode) {
      case 200:
        return ProfileModel.fromJsonCreate(response.data);
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }


  @override
  Future<Map<String, dynamic>> getAdminStatistics() async {
    final response = await dio.get("/api/v1/admin/dashboard");
    switch (response.statusCode) {
      case 200:
        return response.data;
      default:
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: jsonEncode(response.data),
        );
    }
  }
}
