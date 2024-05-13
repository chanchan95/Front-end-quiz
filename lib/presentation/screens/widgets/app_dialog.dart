import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptit_quiz_frontend/core/router/app_router.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/user/manage_course_dialog.dart';
import 'package:ptit_quiz_frontend/presentation/screens/user/manage_exam_dialog.dart';
import 'package:ptit_quiz_frontend/presentation/screens/user/manage_user_dialog.dart';

class AppDialog {
  static Future<bool?> showLeavePageDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave Page'),
          content: const Text(
              'Your answers will not be saved. Are you sure you want to leave?'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  static showSubmitDialog(BuildContext context, VoidCallback onSubmitted) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Submit exam'),
          content: const Text('Are you sure you want to submit the exam?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onSubmitted();
                // AppDialog.showResultDialog(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  static showManageExamDialog(BuildContext context, VoidCallback onManage,
      {bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          content: Container(
            width: 600,
            constraints: const BoxConstraints(
              maxHeight: 600,
            ),
            child: ManageExamDialog(isEdit: isEdit),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onManage();
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        );
      },
    );
  }

  static showUserProfileDialog(BuildContext context, {bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          content: Container(
            width: 600,
            constraints: const BoxConstraints(
              maxHeight: 600,
            ),
            child: MannageUserDialog(isEdit: isEdit)
          ),
          
        );
      },
    );
  }

  static showManageCourseDialog(BuildContext context, VoidCallback onManage,
      {bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          content: Container(
            width: 600,
            constraints: const BoxConstraints(
              maxHeight: 600,
            ),
            child: ManageCourseDialog(isEdit: isEdit),
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //     child: const Text('Cancel'),
          //   ),
          //   TextButton(
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //       onManage();
          //     },
          //     child: Text(isEdit ? 'Update' : 'Create'),
          //   ),
          // ],
        );
      },
    );
  }

  static showResultDialog(BuildContext context, Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) {
        // save context to use in the future
        // var currentContext =
        //     context.read<ExamDetailBloc>().state as ExamDetailSubmitted;
        return AlertDialog(
          title: const Text('Result'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Điểm ' + result['result'].toString(),
                  style: const TextStyle(fontSize: 24)),
              SizedBox(height: 16),
              Text(
                  'Số câu làm đúng: ' +
                      result['rightAnswer'].toString() +
                      '/' +
                      result['totalQuestions'].toString(),
                  style: const TextStyle(fontSize: 24)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                context.go(AppRoutes.home);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
