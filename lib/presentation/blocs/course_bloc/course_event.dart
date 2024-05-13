part of 'course_bloc.dart';

abstract class CourseEvent extends Equatable {
  const CourseEvent();
}

class FetchCoursesEvent extends CourseEvent {
  final String sortKey;
  final String sortOrder;
  const FetchCoursesEvent({required this.sortKey, required this.sortOrder});
  @override
  List<Object> get props => [];
}

class CreateCourseEvent extends CourseEvent {
  final Course course;
  const CreateCourseEvent({required this.course});
  @override
  List<Object> get props => [course];
}

class UpdateCourseEvent extends CourseEvent {
  final Course course;
  const UpdateCourseEvent({required this.course});
  @override
  List<Object> get props => [course];
}

class DeleteCourseEvent extends CourseEvent {
  final String id;
  const DeleteCourseEvent({required this.id});
  @override
  List<Object> get props => [id];
}

class FetchCourseAdminEvent extends CourseEvent {
  final String sortKey;
  final String sortOrder;
  const FetchCourseAdminEvent({required this.sortKey, required this.sortOrder});
  @override
  List<Object> get props => [];
}

class FetchCourseEvent extends CourseEvent {
  final String id;
  const FetchCourseEvent({required this.id});
  @override
  List<Object> get props => [id];
}
