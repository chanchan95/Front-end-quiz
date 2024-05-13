import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ListCourseCubit extends Cubit<List<Course>> {
  ListCourseCubit() : super([]);

  void setCourses(List<Course> courses) => emit(courses);


}