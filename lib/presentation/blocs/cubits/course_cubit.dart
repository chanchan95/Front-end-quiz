import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';

class CourseCubit extends Cubit<Course> {
  CourseCubit() : super(Course.empty());

  void setCourse(Course course) => emit(course);

  void setName(String name) {
    final course = state.copyWith(title: name);
    emit(course);
  }

  void setCredit(int credit) {
    final course = state.copyWith(credit: credit);
    emit(course);
  }

  void setLecturer(String lecturer) {
    final course = state.copyWith(lecturer: lecturer);
    emit(course);
  }

  void setDepartment(String department) {
    final course = state.copyWith(department: department);
    emit(course);
  }

  void setStatus(String status) {
    final course = state.copyWith(status: status);
    emit(course);
  }
  

  void clear() => emit(Course.empty());
}