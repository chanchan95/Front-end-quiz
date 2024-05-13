import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/entities/exam.dart';
import 'package:ptit_quiz_frontend/domain/entities/question.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/list_courses_cubit.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/list_question.dart';

import '../../../core/utils/datetime_picker.dart';
import '../../blocs/cubits/exam_cubit.dart';

class ManageExamDialog extends StatefulWidget {
  const ManageExamDialog({super.key, required this.isEdit});

  final bool isEdit;

  @override
  State<ManageExamDialog> createState() => _ManageExamDialogState();
}

class _ManageExamDialogState extends State<ManageExamDialog> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEdit ? 'Edit Exam' : 'Create Exam'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Exam Details'),
              Tab(text: 'Questions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ExamDetailsTab(),
            QuestionsTab(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ListQuestionCubit>().clearQuestions();
  }
}

class ExamDetailsTab extends StatefulWidget {
  const ExamDetailsTab({super.key});

  @override
  State<ExamDetailsTab> createState() => _ExamDetailsTabState();
}

class _ExamDetailsTabState extends State<ExamDetailsTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _totalMarksController = TextEditingController();
  final TextEditingController _typeController =
      TextEditingController(text: 'unlimited');
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _idCourseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Course> courses = context.read<ListCourseCubit>().state;
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
        minWidth: 500,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _totalMarksController,
              decoration: const InputDecoration(labelText: 'Total Marks'),
            ),
            DropdownButtonFormField<String>(
              value: _idCourseController.text.isNotEmpty
                  ? _idCourseController.text
                  : null,
              onChanged: (value) {
                setState(() {
                  _idCourseController.text = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Course'),
              items: courses
                  .map(
                    (course) => DropdownMenuItem(
                      value: course.id,
                      child: Text(course.title),
                    ),
                  )
                  .toList(),
            ),
            DropdownButtonFormField<String>(
              // value: _typeController.text,
              value:
                  _typeController.text.isNotEmpty ? _typeController.text : null,
              onChanged: (value) {
                setState(() {
                  _typeController.text = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Type'),
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  value: 'limited',
                  child: const Text('Limited'),
                ),
                DropdownMenuItem(
                  value: 'unlimited',
                  child: const Text('Unlimited'),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _statusController.text,
              onChanged: (value) {
                setState(() {
                  _statusController.text = value!;
                });
              },
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                DropdownMenuItem(
                  value: 'active',
                  child: const Text('Active'),
                ),
                DropdownMenuItem(
                  value: 'inactive',
                  child: const Text('Inactive'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Save Exam'),
              onPressed: () {
                Exam thisExam = Exam(
                  id: '',
                  title: _nameController.text,
                  description: _descriptionController.text,
                  totalPoint: int.parse(_totalMarksController.text),
                  type: _typeController.text,
                  status: _statusController.text,
                  courseId: _idCourseController.text,
                  // questions: context.read<ListQuestionCubit>().state,
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // String datetimeOfExam = context.read<ExamCubit>().state.timeStart!;
    _nameController.text = context.read<ExamCubit>().state.title;
    _descriptionController.text = context.read<ExamCubit>().state.description;
    _totalMarksController.text =
        context.read<ExamCubit>().state.totalPoint.toString();
    _typeController.text = context.read<ExamCubit>().state.type;
    _statusController.text = context.read<ExamCubit>().state.status;
    _idCourseController.text = context.read<ExamCubit>().state.courseId;

    _nameController.addListener(() {
      context.read<ExamCubit>().setName(_nameController.text);
    });
    _descriptionController.addListener(() {
      context.read<ExamCubit>().setDescription(_descriptionController.text);
    });
    _totalMarksController.addListener(() {
      context
          .read<ExamCubit>()
          .setTotalPoint(int.parse(_totalMarksController.text));
    });
    _typeController.addListener(() {
      context.read<ExamCubit>().setType(_typeController.text);
    });
    _statusController.addListener(() {
      context.read<ExamCubit>().setStatus(_statusController.text);
    });
    _idCourseController.addListener(() {
      context.read<ExamCubit>().setCourseId(_idCourseController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _totalMarksController.dispose();
    _typeController.dispose();
    _statusController.dispose();
    super.dispose();
  }
}

class QuestionsTab extends StatefulWidget {
  QuestionsTab({super.key});
  List<Question> questions = [];
  @override
  State<QuestionsTab> createState() => _QuestionsTabState();
}

class _QuestionsTabState extends State<QuestionsTab> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> listQuestion =
        List.generate(count, (int i) => new QuestionDetailCard());
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          addNewQuestion();
        },
        child: new Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: listQuestion,
        ),
      ),
    );
  }

  void addNewQuestion() {
    setState(() {
      count++;
    });
  }
}

class QuestionDetailCard extends StatelessWidget {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _option0Controller = TextEditingController();
  final TextEditingController _option1Controller = TextEditingController();
  final TextEditingController _option2Controller = TextEditingController();
  final TextEditingController _option3Controller = TextEditingController();
  final TextEditingController _rightOptionController = TextEditingController();
  final TextEditingController _explainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 350, // Adjust the height value as desired
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.red[100]!,
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(children: [
          Column(
            children: [
              Text('Question'),
              SizedBox(
                height: 45, // Adjust the height value as desired
                child: TextField(
                  controller: _questionController,
                  decoration: const InputDecoration(hintText: 'Question'),
                ),
              ),
              SizedBox(
                height: 45, // Adjust the height value as desired
                child: TextField(
                  controller: _option0Controller,
                  decoration: const InputDecoration(hintText: 'Option 1'),
                ),
              ),
              SizedBox(
                height: 45, // Adjust the height value as desired
                child: TextField(
                  controller: _option1Controller,
                  decoration: const InputDecoration(hintText: 'Option 2'),
                ),
              ),
              SizedBox(
                height: 45, // Adjust the height value as desired
                child: TextField(
                  controller: _option2Controller,
                  decoration: const InputDecoration(hintText: 'Option 3'),
                ),
              ),
              SizedBox(
                height: 45, // Adjust the height value as desired
                child: TextField(
                  controller: _option3Controller,
                  decoration: const InputDecoration(hintText: 'Option 4'),
                ),
              ),
              SizedBox(
                height: 45, // Adjust the height value as desired
                child: TextField(
                  controller: _rightOptionController,
                  decoration: const InputDecoration(hintText: 'Right Option'),
                ),
              ),
              SizedBox(
                height: 45, // Adjust the height value as desired
                child: TextField(
                  controller: _explainController,
                  decoration: const InputDecoration(hintText: 'Explain'),
                ),
              ),
            ],
          ),
          ElevatedButton.icon(
            label: Text('Done'),
            icon: Icon(Icons.verified),
            onPressed: () {
              Question thisQuestion = Question(
                id: '',
                content: _questionController.text,
                answers: [
                  _option0Controller.text,
                  _option1Controller.text,
                  _option2Controller.text,
                  _option3Controller.text,
                ],
                correctAnswer: int.parse(_rightOptionController.text),
                explaination: _explainController.text,
              );
              // print(thisQuestion.answers);
              context.read<ListQuestionCubit>().addQuestion(
                    thisQuestion,
                  );
            },
          ),
        ]),
      ),
    );
  }
}
