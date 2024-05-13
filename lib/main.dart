import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// ignore: unused_import
import 'package:ptit_quiz_frontend/core/constants/bloc_observer/bloc_observer.dart';
import 'package:ptit_quiz_frontend/core/theme/color_schemes.g.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/course_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/list_courses_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/list_question.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/user_profile_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/user_profile_bloc/user_profile_bloc.dart';

import 'di.dart';
import 'core/router/app_router.dart';
import 'presentation/blocs/app_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjection.init();
  await dotenv.load(fileName: 'dotenv');

  // debug
  // Bloc observer_bloc = DependencyInjection.sl<ExamDetailBloc>();
  // Bloc.observer = AppBlocObserver();

  FlutterNativeSplash.remove();
  
  runApp(
    MultiBlocProvider(
      providers: [

        BlocProvider<UserProfileBloc> (create: (context) => DependencyInjection.sl<UserProfileBloc>()),
        BlocProvider<CourseBloc>(create: (context) => DependencyInjection.sl<CourseBloc>()),
        BlocProvider<AuthBloc>(create: (context) => DependencyInjection.sl<AuthBloc>()),
        BlocProvider<ExamBloc>(create: (context) => DependencyInjection.sl<ExamBloc>()),
        BlocProvider<ExamDetailBloc>(create: (context) => DependencyInjection.sl<ExamDetailBloc>()),
        BlocProvider<ResultBloc>(create: (context) => DependencyInjection.sl<ResultBloc>()),
        BlocProvider<ResultDetailBloc>(create: (context) => DependencyInjection.sl<ResultDetailBloc>()),
        BlocProvider<StatisticsBloc>(create: (context) => DependencyInjection.sl<StatisticsBloc>()),
        BlocProvider<AnswersCubit>(create: (context) => DependencyInjection.sl<AnswersCubit>()),
        BlocProvider<TimerCubit>(create: (context) => DependencyInjection.sl<TimerCubit>()),
        BlocProvider<CourseCubit>(create: (context) => DependencyInjection.sl<CourseCubit>()),
        BlocProvider<ListCourseCubit>(create: (context) => DependencyInjection.sl<ListCourseCubit>()),
        BlocProvider<ExamCubit>(create: (context) => DependencyInjection.sl<ExamCubit>()),
        BlocProvider<UserProfileCubit>(create: (context) => DependencyInjection.sl<UserProfileCubit>()),
        BlocProvider<ListQuestionCubit>(create: (context) => DependencyInjection.sl<ListQuestionCubit>()),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PTIT Quiz',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.appRouter,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
    );
  }
}
