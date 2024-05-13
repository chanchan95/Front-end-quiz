import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/course_bloc/course_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/course_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/list_courses_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/app_dialog.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/app_loading_animation.dart';
import 'package:toastification/toastification.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, this.isAdmin = false});
  final bool isAdmin;
  @override
  State<CourseScreen> createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late List<Course> courses;
  var sortKey = 'title';
  var sortOrder = 'asc';
  var limit = 3;
  var current_page = 0;
  List<String> sortOptions = ['title', 'credits', 'lecturer'];
  List<String> sortValues = ['asc', 'desc'];
  @override
  Widget build(BuildContext context) {
    print(widget.isAdmin);
    return BlocConsumer<CourseBloc, CourseState>(
      listener: (context, state) {
        if (state is CourseStateError) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: const Text('Error'),
              description: Text(state.message),
              alignment: Alignment.topRight,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          });
        } else if (state is CourseStateListLoaded) {
          courses = state.courses;
        }
      },
      //

      builder: (context, state) {
        context.read<ListCourseCubit>().setCourses(courses);
        if (state is CourseStateLoading) {
          return const AppLoadingAnimation();
        } else if (state is CourseStateListLoaded) {
          var courses_length = state.courses.length;
          var number_of_pages = (courses_length / limit).ceil();

          List<Course> current_courses = state.courses.sublist(
              current_page * limit,
              min((current_page + 1) * limit, courses_length));

          return SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: 1000,
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (widget.isAdmin) ...[
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        // context.read<ExamCubit>().setExam(const Exam.empty());
                                        // AppDialog.showManageExamDialog(context, () { });
                                        // print('Add course button pressed');
                                        context
                                            .read<CourseCubit>()
                                            .setCourse(Course.empty());
                                        AppDialog.showManageCourseDialog(
                                            context, () {});
                                        print('Add course button pressed');
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  IconButton(
                                    icon: const Icon(
                                      Icons.cached,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<CourseBloc>(context).add(
                                          widget.isAdmin
                                              ? FetchCourseAdminEvent(
                                                  sortKey: sortKey,
                                                  sortOrder: sortOrder)
                                              : FetchCoursesEvent(
                                                  sortKey: sortKey,
                                                  sortOrder: sortOrder));
                                      // FetchCoursesEvent(
                                      //     sortKey: sortKey,
                                      //     sortOrder: sortOrder));
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    width: min(
                                        MediaQuery.of(context).size.width * 0.4,
                                        300),
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 12,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Sắp xếp theo: '),
                                            PopupMenuButton(
                                              child: Text(sortKey),
                                              // icon: const Icon(
                                              //   Icons.question_mark,
                                              //   color: Colors.grey,
                                              // ),
                                              itemBuilder: (context) => [
                                                for (var option in sortOptions)
                                                  PopupMenuItem(
                                                    child: Text(option),
                                                    value: option,
                                                  ),
                                              ],
                                              onSelected: (value) {
                                                setState(() {
                                                  sortKey = value.toString();
                                                });
                                              },
                                            ),
                                            SizedBox(width: 30),
                                            Row(
                                              children: [
                                                Text('với thứ tự: '),
                                                PopupMenuButton(
                                                  child: Text(
                                                      (sortOrder == 'asc')
                                                          ? 'tăng dần'
                                                          : 'giảm dần'),
                                                  // icon: const Icon(
                                                  //   Icons.sort,
                                                  //   color: Colors.grey,
                                                  // ),
                                                  itemBuilder: (context) => [
                                                    PopupMenuItem(
                                                      child: Text('Tăng dần'),
                                                      value: sortValues[0],
                                                    ),
                                                    PopupMenuItem(
                                                      child: Text('Giảm dần'),
                                                      value: sortValues[1],
                                                    ),
                                                  ],
                                                  onSelected: (value) {
                                                    setState(() {
                                                      sortOrder =
                                                          value.toString();
                                                    });
                                                    // context.read<CourseBloc>().add(FetchCoursesEvent(sortKey: sortKey, sortOrder: value.toString()));
                                                  },
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: current_courses.length,
                              itemBuilder: (context, index) {
                                return CourseCard(
                                  course: current_courses[index],
                                  onPressed: () {
                                    // hiện lên dialog gồm thông tin chi tiết của course
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              current_courses[index].title),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(current_courses[index]
                                                  .description),
                                              const SizedBox(height: 10),
                                              Text(
                                                  'Credit: ${current_courses[index].credit}'),
                                              const SizedBox(height: 10),
                                              Text(
                                                  'Lecturer: ${current_courses[index].lecturer}'),
                                              const SizedBox(height: 10),
                                              Text(
                                                  'Department: ${current_courses[index].department}'),
                                              const SizedBox(height: 10),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            Text(
                                'Page ${current_page + 1} of $number_of_pages'),
                            Center(
                              child: Container(
                                width: 400,
                                child: NumberPaginator(
                                    numberPages: number_of_pages,
                                    onPageChange: (int index) {
                                      setState(() {
                                        current_page = index;
                                      });
                                      // print('Page changed to $current_page');
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin) {
      context
          .read<CourseBloc>()
          .add(FetchCourseAdminEvent(sortKey: sortKey, sortOrder: sortOrder));
    } else {
      context
          .read<CourseBloc>()
          .add(FetchCoursesEvent(sortKey: sortKey, sortOrder: sortOrder));
    }
    // context
    //     .read<CourseBloc>()
    //     .add(FetchCoursesEvent(sortKey: sortKey, sortOrder: sortOrder));
    courses = [];
  }
}

class CourseCard extends StatelessWidget {
  const CourseCard({Key? key, required this.course, this.onPressed});

  final Course course;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    bool isMedium = MediaQuery.of(context).size.width > 800;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Flex(
              direction: isMedium ? Axis.horizontal : Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Image.asset(
                    'assets/images/course.png',
                    width: isMedium ? 120 : 50,
                    height: isMedium ? 120 : 50,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      course.description,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Credit: ${course.credit}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lecturer: ${course.lecturer}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                isMedium ? const Spacer() : const SizedBox(height: 20),
              ]),
        ),
      ),
    );
  }
}
