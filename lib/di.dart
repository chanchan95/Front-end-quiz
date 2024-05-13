import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:ptit_quiz_frontend/core/utils/ticker.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/usecases/create_course.dart';
import 'package:ptit_quiz_frontend/domain/usecases/create_user.dart';
import 'package:ptit_quiz_frontend/domain/usecases/forgot_password.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_courses.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_courses_admin.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_exam_result.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_exam_results.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_exams_admin.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_users_profiles.dart';
import 'package:ptit_quiz_frontend/domain/usecases/otp_password.dart';
import 'package:ptit_quiz_frontend/domain/usecases/reset_password.dart';
import 'package:ptit_quiz_frontend/domain/usecases/submit_exam.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/course_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/list_courses_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/user_profile_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/user_profile_bloc/user_profile_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/dio/dio_tools.dart';
import 'domain/usecases/validate.dart';
import 'domain/usecases/validate_admin.dart';
import 'presentation/blocs/app_bloc.dart';

import 'data/providers/remote_data.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/providers/local_data.dart';
import 'data/repositories/exam_repository_impl.dart';

import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/logout.dart';
import 'domain/repositories/exam_repository.dart';
import 'domain/usecases/admin_login.dart';
import 'domain/usecases/create_exam.dart';
import 'domain/usecases/delete_exam.dart';
import 'domain/usecases/get_exam.dart';
import 'domain/usecases/get_exams.dart';
import 'domain/usecases/register.dart';
import 'domain/usecases/update_exam.dart';

class DependencyInjection {
  static final GetIt sl = GetIt.instance;

  static Future<void> init() async {
    // bloc
    sl.registerFactory<AuthBloc>(
      () => AuthBloc(

        login: sl(),
        logout: sl(),
        register: sl(),
        adminLogin: sl(),
        validate: sl(),
        validateAdmin: sl(),
        forgotPassword: sl(),
        otpPassword: sl(),
        resetPassword: sl(),
        authSubscription: DioTools.registerInceptor(sl<Dio>()),
      ),
    );

    sl.registerFactory<ExamBloc>(
      () => ExamBloc(
        getExams: sl(),
        getExamsAdmin: sl(),
        getExam: sl(),
        createExam: sl(),
        updateExam: sl(),
        deleteExam: sl(),
      ),
    );

    sl.registerFactory<CourseBloc>(
      () => CourseBloc(
        getCourses: sl(),
        getCoursesAdmin: sl(),
        createCourse  : sl(),
      ),
    );

    sl.registerFactory<ExamDetailBloc>(
      () => ExamDetailBloc(
        getExam: sl(),
        submitExam: sl(),
      ),
    );

    sl.registerFactory<ResultBloc>(
      () => ResultBloc(
        getExamResults: sl(),
      ),
    );

    sl.registerFactory<UserProfileBloc>(
      () => UserProfileBloc(
        getUsersProfiles: sl(),
        createProfile: sl(),
      ),
    );
    

    sl.registerFactory<ResultDetailBloc>(
      () => ResultDetailBloc(
        getExamResult: sl(),
      ),
    );

    sl.registerFactory<AnswersCubit>(
      () => AnswersCubit(),
    );

    sl.registerFactory<TimerCubit>(
      () => TimerCubit(ticker: const Ticker()),
    );

    sl.registerFactory<ExamCubit>(
      () => ExamCubit(),
    );

    sl.registerFactory<CourseCubit>(
      () => CourseCubit(),
    );

    sl.registerFactory<ListCourseCubit>(
      () => ListCourseCubit(),
    );

    sl.registerFactory<UserProfileCubit>(
      () => UserProfileCubit(),
    );
    // use case
    
    sl.registerLazySingleton<Login>(() => Login(authRepository: sl()));
    sl.registerLazySingleton<Logout>(() => Logout(authRepository: sl()));
    sl.registerLazySingleton<Register>(() => Register(authRepository: sl()));
    sl.registerLazySingleton<AdminLogin>(() => AdminLogin(authRepository: sl())); 
    sl.registerLazySingleton<Validate>(() => Validate(authRepository: sl()));
    sl.registerLazySingleton<ValidateAdmin>(() => ValidateAdmin(authRepository: sl()));
    sl.registerLazySingleton<ForgotPassword>(() => ForgotPassword(authRepository: sl()));
    sl.registerLazySingleton<OtpPassword>(() => OtpPassword(authRepository: sl()));
    sl.registerLazySingleton<ResetPassword>(() => ResetPassword(authRepository: sl()));
    sl.registerLazySingleton<GetExams>(() => GetExams(examRepository: sl()));
    sl.registerLazySingleton<GetExamsAdmin>(() => GetExamsAdmin(examRepository: sl()));
    sl.registerLazySingleton<GetExam>(() => GetExam(examRepository: sl()));
    sl.registerLazySingleton<getCourses>(() => getCourses(examRepository: sl()));
    sl.registerLazySingleton<getCoursesAdmin>(() => getCoursesAdmin(examRepository: sl()));
    sl.registerLazySingleton<CreateCourse>(() => CreateCourse(examRepository: sl()));
    sl.registerLazySingleton<CreateExam>(() => CreateExam(examRepository: sl()));
    sl.registerLazySingleton<SubmitExam>(() => SubmitExam(examRepository: sl()));
    sl.registerLazySingleton<GetExamResult>(() => GetExamResult(examRepository: sl()));
    sl.registerLazySingleton<GetExamResults>(() => GetExamResults(examRepository: sl()));
    sl.registerLazySingleton<UpdateExam>(() => UpdateExam(examRepository: sl()));
    sl.registerLazySingleton<DeleteExam>(() => DeleteExam(examRepository: sl()));
    sl.registerLazySingleton<getUsersProfiles>(() => getUsersProfiles(examRepository: sl()));
    sl.registerLazySingleton<CreateUser>(() => CreateUser(examRepository: sl()));

    // repository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        localData: sl(),
        remoteData: sl(),
      ),
    );
    sl.registerLazySingleton<ExamRepository>(
      () => ExamRepositoryImpl(remoteData: sl())
    );

    // data
    sl.registerLazySingleton<RemoteData>(() => RemoteDataImpl(dio: sl()));
    sl.registerLazySingleton<LocalData>(() => LocalDataImpl(sharedPreferences: sl()));

    // third party
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    sl.registerLazySingleton<Dio>(() => DioTools.dio);
  }
}