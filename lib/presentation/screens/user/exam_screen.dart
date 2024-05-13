import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:ptit_quiz_frontend/domain/entities/exam.dart';
import 'package:ptit_quiz_frontend/domain/entities/question.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/list_question.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/exam_bloc/exam_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/app_dialog.dart';
import 'package:ptit_quiz_frontend/presentation/screens/widgets/widgets.dart';
import 'package:toastification/toastification.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key, this.isAdmin = false});

  final bool isAdmin;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late List<Exam> exams;
  var sortKey = 'title';
  var sortOrder = 'asc';
  var limit = 3;
  var current_page = 0;

  List<String> sortOptions = ['title', 'finish', 'type'];
  List<String> sortValues = ['asc', 'desc'];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamStateError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
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
        }
        if (state is ExamStateListLoaded) {
          exams = state.exams;
        }
      },
      builder: (context, state) {
        if (state is ExamStateLoading) {
          return const Center(
            child: AppLoadingAnimation(),
          );
        } else if (state is ExamStateListLoaded) {
          var exams_length = state.exams.length;
          var number_of_pages = (exams_length / limit).ceil();
          List<Exam> current_exams = state.exams.sublist(current_page * limit,
              min((current_page + 1) * limit, exams_length));

          final ongoingExams = exams;
          final upcomingExams = [];
          // final ongoingExams = exams.where((exam) => exam.timeStart != null && exam.start! < DateTime.now().millisecondsSinceEpoch).toList();
          // final upcomingExams = exams.where((exam) => exam.timeStart == null || exam.start! > DateTime.now().millisecondsSinceEpoch).toList();
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
                                        context
                                            .read<ExamCubit>()
                                            .setExam(const Exam.empty());
                                        AppDialog.showManageExamDialog(
                                          context,
                                          () {
                                            Exam thisexam =
                                                context.read<ExamCubit>().state;
                                            List<Question> questions = context.read<ListQuestionCubit>().state;

                                            if (thisexam.title.isEmpty) {
                                              toastification.show(
                                                context: context,
                                                type: ToastificationType.error,
                                                style: ToastificationStyle.flatColored,
                                                title: const Text('Error'),
                                                description: const Text('Title is required'),
                                                alignment: Alignment.topRight,
                                                autoCloseDuration: const Duration(seconds: 3),
                                                showProgressBar: false,
                                              );
                                              return;
                                            }


                                          },
                                        );
                                        print('Add exam button pressed');
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
                                      BlocProvider.of<ExamBloc>(context).add(
                                        widget.isAdmin
                                            ? FetchExamsAdminEvent(
                                                sortKey: sortKey,
                                                sortValue: sortOrder)
                                            : FetchExamsEvent(
                                                sortKey: sortKey,
                                                sortValue: sortOrder),
                                      );
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
                            const SizedBox(height: 10),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Ongoing Exams',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (ongoingExams.isNotEmpty)
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: current_exams.length,
                                itemBuilder: (context, index) {
                                  final exam = current_exams[index];
                                  return ExamCard(
                                      exam: exam,
                                      onPressed: widget.isAdmin
                                          ? () {
                                              context
                                                  .read<ExamCubit>()
                                                  .setExam(exam);
                                              AppDialog.showManageExamDialog(
                                                  context, () {},
                                                  isEdit: true);
                                            }
                                          : () {
                                              context.go('/exam/${exam.id}');
                                            },
                                      isAdmin: widget.isAdmin);
                                },
                              )
                            else
                              const Center(
                                child: Text(
                                  'No ongoing exams',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            const SizedBox(height: 20),
                            // Container(
                            //   alignment: Alignment.centerLeft,
                            //   child: const Text(
                            //     'Upcoming Exams',
                            //     textAlign: TextAlign.start,
                            //     style: TextStyle(
                            //       color: Colors.black,
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   ),
                            // ),
                            // const SizedBox(height: 10),
                            // if (upcomingExams.isNotEmpty)
                            //   ListView.builder(
                            //     shrinkWrap: true,
                            //     itemCount: upcomingExams.length,
                            //     itemBuilder: (context, index) {
                            //       final exam = upcomingExams[index];
                            //       return ExamCard(
                            //           exam: exam,
                            //           onPressed: widget.isAdmin
                            //               ? () {
                            //                   context
                            //                       .read<ExamCubit>()
                            //                       .setExam(exam);
                            //                   AppDialog.showManageExamDialog(
                            //                       context, () {},
                            //                       isEdit: true);
                            //                 }
                            //               : null,
                            //           isAdmin: widget.isAdmin);
                            //     },
                            //   )
                            // else
                            //   const Center(
                            //     child: Text(
                            //       'No upcoming exams',
                            //       style: TextStyle(fontSize: 20),
                            //     ),
                            //   ),
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
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                )),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text(
              'No exams found',
              style: TextStyle(fontSize: 24),
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isAdmin)
      context
          .read<ExamBloc>()
          .add(FetchExamsAdminEvent(sortKey: sortKey, sortValue: sortOrder));
    else
      context
          .read<ExamBloc>()
          .add(FetchExamsEvent(sortKey: sortKey, sortValue: sortOrder));
    // context.read<ExamBloc>().add(const FetchExamsEvent());
    exams = [];
  }

  void searchExams(String query) {
    List<Exam> stateExams =
        (context.read<ExamBloc>().state as ExamStateListLoaded).exams;
    setState(() {
      exams = stateExams
          .where(
              (exam) => exam.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.exam,
    required this.onPressed,
    this.isAdmin = false,
  });

  final Exam exam;
  final Function()? onPressed;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    bool isMedium = MediaQuery.of(context).size.width > 800;
    return Column(
      children: [
        Container(
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
            child: Flex(
              direction: isMedium ? Axis.horizontal : Axis.vertical,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(
                    'assets/images/exam.png',
                    width: 120,
                    height: 120,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Duration: ${exam.duration} minutes',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (exam.timeStart != null)
                      Text(
                        'Start: ' +
                            '${DateTime.parse(exam.timeStart!).toLocal()}'
                                .substring(0, 16),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    if (exam.timeFinish != null)
                      Text(
                        'Finish: ' +
                            '${DateTime.parse(exam.timeFinish!).toLocal()}'
                                .substring(0, 16),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    if (exam.type == 'unlimited')
                      Text(
                        'Exam type: Unlimited',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
                isMedium ? const Spacer() : const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Padding(
                      padding: isAdmin
                          ? const EdgeInsets.all(12)
                          : const EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          isAdmin ? 'Edit' : 'On Going',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        const SizedBox(height: 20),
      ],
    );
  }
}
