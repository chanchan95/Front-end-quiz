import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ptit_quiz_frontend/core/router/app_router.dart';
import 'package:ptit_quiz_frontend/data/models/course_model.dart';
import 'package:ptit_quiz_frontend/data/providers/remote_data.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/app_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/course_bloc/course_bloc.dart';
import 'package:ptit_quiz_frontend/presentation/blocs/cubits/course_cubit.dart';

class ManageCourseDialog extends StatefulWidget {
  const ManageCourseDialog({Key? key, required this.isEdit}) : super(key: key);

  final bool isEdit;

  @override
  State<ManageCourseDialog> createState() => _ManageCourseDialogState();
}

class _ManageCourseDialogState extends State<ManageCourseDialog> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEdit ? 'Edit Course' : 'Create Course'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Course Details'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CourseDetailsTab(
              isEdit: widget.isEdit,
            ),
          ],
        ),
      ),
    );
  }
}

class CourseDetailsTab extends StatefulWidget {
  const CourseDetailsTab({Key? key, required this.isEdit});
  final bool isEdit;

  @override
  State<CourseDetailsTab> createState() => _CourseDetailsTabState();
}

class _CourseDetailsTabState extends State<CourseDetailsTab> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _creditController = TextEditingController();
  final TextEditingController _lecturerController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  String status = 'active';
  @override
  Widget build(BuildContext context) {
    
    return Container(
      constraints: const BoxConstraints(
        minHeight: 200,
        minWidth: 500,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _creditController,
            decoration: const InputDecoration(labelText: 'Credit'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _lecturerController,
            decoration: const InputDecoration(labelText: 'Lecturer'),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _departmentController,
            decoration: const InputDecoration(labelText: 'Department'),
          ),
          const SizedBox(height: 16),
          // choice of status

          DropdownButtonFormField<String>(
            value: status,
            onChanged: (String? value) {},
            items: [
              DropdownMenuItem(
                value: 'active',
                child: Text('Active'),
                onTap: () {
                  setState(() {
                    status = 'active';
                  });
                },
              ),
              DropdownMenuItem(
                value: 'inactive',
                child: Text('Inactive'),
                onTap: () {
                  setState(() {
                    status = 'inactive';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Course thiscourse = Course(
                id: '',
                title: _titleController.text,
                description: _descriptionController.text,
                credit: int.parse(_creditController.text),
                lecturer: _lecturerController.text,
                department: _departmentController.text,
                status: status,
              );
              if (widget.isEdit) {
                print('update course');
              } else {
                print("create course");
                context
                    .read<CourseBloc>()
                    .add(CreateCourseEvent(course: thiscourse));
                Navigator.of(context).pop();
                context.read<CourseBloc>().add(FetchCourseAdminEvent(sortKey: 'title', sortOrder: 'asc'));
              }
            },
            child: Text(widget.isEdit ? 'Update Course' : 'Create Course'),
          ),
        ],
      ),
    );
  }
}
