import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ptit_quiz_frontend/domain/entities/course.dart';
import 'package:ptit_quiz_frontend/domain/usecases/create_course.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_courses.dart';
import 'package:ptit_quiz_frontend/domain/usecases/get_courses_admin.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  late getCourses _getCourses;
  late getCoursesAdmin _getCoursesAdmin;
  late CreateCourse _createCourse;
  CourseBloc({
    required getCourses getCourses,
    required getCoursesAdmin getCoursesAdmin,
    required CreateCourse createCourse,
  }) : super(const CourseState()) {
    _getCourses = getCourses;
    _getCoursesAdmin = getCoursesAdmin;
    _createCourse = createCourse;
    on<FetchCoursesEvent>(_onFetchCourses);
    on<FetchCourseAdminEvent>(_onFetchCourseAdmin);
    on<CreateCourseEvent>(_onCreateCourse);
    // add(const FetchCoursesEvent(sortKey: 'title', sortOrder: 'asc'));
  }

  Future<void> _onFetchCourses(
      FetchCoursesEvent event, Emitter<CourseState> emit) async {
    emit(const CourseStateLoading());
    try {
      final courses = await _getCourses(event.sortKey, event.sortOrder);
      emit(CourseStateListLoaded(courses: courses));
    } catch (e) {
      emit(CourseStateError(message: e.toString()));
    }
  }

  // FetchCourseAdmin
  Future<void> _onFetchCourseAdmin(
      FetchCourseAdminEvent event, Emitter<CourseState> emit) async {
    emit(const CourseStateLoading());
    try {
      final courses = await _getCoursesAdmin(event.sortKey, event.sortOrder);
      emit(CourseStateListLoaded(courses: courses));
    } catch (e) {
      emit(CourseStateError(message: e.toString()));
    }
  }

  // CreateCourse
  Future<void> _onCreateCourse(
      CreateCourseEvent event, Emitter<CourseState> emit) async {
    emit(const CourseStateLoading());
    try {
      print('TESTTTTTTT_FIRST');
      final course = await _createCourse(event.course);
      print('TESTTTTTTT_SECOND');
      emit(CourseStateCreated(course: course));
    } catch (e) {
      print('TESTTTTTTT_THIRD');
      emit(CourseStateError(message: e.toString()));
    }
  }
}
