import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/course_bloc/course_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/user/course_screen.dart';
import 'package:ptit_quiz_frontend/presentation/screens/user/result_long_sceen.dart';
// import 'package:ptit_quiz_frontend/presentation/screens/auth/otp_password_screen.dart';

import '../../presentation/screens/screen.dart';
import '../../presentation/screens/widgets/app_dialog.dart';
import '../../presentation/screens/widgets/widgets.dart';

part 'app_routes.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static get appRouter => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppRoutes.home,
        redirect: (context, state) {
          final authState = context.read<AuthBloc>().state;

          if (authState is! AuthStateAuthenticated &&
              authState is! AuthStateAdminAuthenticated) {
            if (!AppRoutes.publicRoutes.contains(state.matchedLocation)) {
              return AppRoutes.login;
            }
            return null;
          } else {
            if (AppRoutes.publicRoutes.contains(state.matchedLocation) ||
                state.matchedLocation == AppRoutes.initial) {
              if (authState is AuthStateAuthenticated) {
                return AppRoutes.home;
              } else if (authState is AuthStateAdminAuthenticated) {
                return AppRoutes.adminStatistics;
              }
            } else if (!AppRoutes.validRoutes.contains(state.matchedLocation) &&
                !state.matchedLocation.startsWith(AppRoutes.exam) &&
                !state.matchedLocation.startsWith(AppRoutes.result)) {
              return AppRoutes.invalidRoute;
            }
            return null;
          }
        },
        routes: [
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state, child) =>
                buildCustomTransitionPage<void>(
              context: context,
              state: state,
              child: AppSideNavigation(child: child),
            ),
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const CourseScreen(),
                ),
              ),

              GoRoute(
                path: AppRoutes.course,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const CourseScreen(),
                ),
              ),

              GoRoute(
                path: AppRoutes.exam,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const ExamScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.result,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: LongResultScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.resultDetail,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: ResultDetailScreen(
                      resultId: state.pathParameters['resultId'] ?? ''),
                ),
              ),
              // Admin Routes
              GoRoute(
                path: AppRoutes.adminExam,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const ExamScreen(
                    isAdmin: true,
                  ),
                ),
              ),

              GoRoute(
                path: AppRoutes.adminCourse,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const CourseScreen(
                    isAdmin: true,
                  ),
                ),
              ),

              GoRoute(
                path: AppRoutes.adminResult,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const AdminResultScreen(),
                ),
              ),
              GoRoute(
                path: AppRoutes.adminStatistics,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const AdminStatisticsScreen(),
                ),
              ),

              GoRoute(
                path: AppRoutes.adminUser,
                pageBuilder: (context, state) =>
                    buildCustomTransitionPage<void>(
                  context: context,
                  state: state,
                  child: const AdminUserScreen(),
                ),
              ),
            ],
          ),

          GoRoute(
            path: AppRoutes.examDetail,
            pageBuilder: (context, state) => buildCustomTransitionPage<void>(
              context: context,
              state: state,
              child: ExamDetailScreen(examId: state.pathParameters['examId']!),
            ),
            onExit: (BuildContext context) async {
              if (context.read<ExamDetailBloc>().state
                  is! ExamDetailSubmitted) {
                return await AppDialog.showLeavePageDialog(context) ?? false;
              }
              return true;
            },
          ),
          // Auth Routes
          GoRoute(
            path: AppRoutes.login,
            pageBuilder: (context, state) => buildCustomTransitionPage<void>(
              context: context,
              state: state,
              child: const LoginScreen(isAdmin: false),
            ),
          ),
          GoRoute(
            path: AppRoutes.adminLogin,
            pageBuilder: (context, state) => buildCustomTransitionPage<void>(
              context: context,
              state: state,
              child: const LoginScreen(isAdmin: true),
            ),
          ),
          GoRoute(
            path: AppRoutes.register,
            pageBuilder: (context, state) => buildCustomTransitionPage<void>(
              context: context,
              state: state,
              child: const RegisterScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.forgotPassword,
            pageBuilder: (context, state) => buildCustomTransitionPage<void>(
              context: context,
              state: state,
              child: const ForgotPasswordScreen(),
            ),
          ),

          // GoRoute(
          //   path: AppRoutes.otpPassword,
          //   pageBuilder: (context, state) => buildCustomTransitionPage<void>(
          //     context: context,
          //     state: state,
          //     child: const OTPPassWordScreen(),
          //   ),
          // ),

          // Invalid Route
          GoRoute(
            path: AppRoutes.invalidRoute,
            pageBuilder: (context, state) => buildCustomTransitionPage<void>(
              context: context,
              state: state,
              child: const Placeholder(),
            ),
          ),
        ],
      );
}

CustomTransitionPage buildCustomTransitionPage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child));
}
