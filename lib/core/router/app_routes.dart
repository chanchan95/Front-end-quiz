part of 'app_router.dart';

class AppRoutes {
  // user routes
  static const initial = '/';
  static const home = '/home';
  static const course = '/course';
  static const exam = '/exam';
  static const examDetail = '/exam/:examId';
  static const result = '/result';
  static const resultDetail = '/result/:resultId';
  // admin routes
  static const adminExam = '/admin/exam-management';
  static const adminCourse = '/admin/course-management';
  static const adminResult = '/admin/result-management';
  static const adminStatistics = '/admin/statistics';
  static const adminUser = '/admin/user-management';
  // auth routes
  static const login = '/auth/login';
  static const adminLogin = '/auth/admin-login';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';
  // static const otpPassword = '/auth/otp-password';
  static const invalidRoute = '/404';

  static const validRoutes = [
    initial,
    home,
    course,
    exam,
    result,
    resultDetail,
    adminExam,
    adminResult,
    adminStatistics,
    adminUser,
    login,
    adminLogin,
    register,
    invalidRoute,
    forgotPassword,
    adminCourse,
    // otpPassword,
  ];

  static const publicRoutes = [
    login,
    adminLogin,
    register,
    forgotPassword,
    // otpPassword,
  ];
}
