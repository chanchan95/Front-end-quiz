part of 'course_bloc.dart';

class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object> get props => [];
}

class CourseStateLoading extends CourseState {
  const CourseStateLoading();

  @override
  List<Object> get props => [];
}

class CourseStateListLoaded extends CourseState {
  final List<Course> courses;
  const CourseStateListLoaded({required this.courses});

  @override
  List<Object> get props => [courses];
}

class CourseStateLoaded extends CourseState {
  final Course course;
  const CourseStateLoaded({required this.course});

  @override
  List<Object> get props => [course];
}

class CourseStateError extends CourseState {
  final String message;
  const CourseStateError({required this.message});

  @override
  List<Object> get props => [message];
}

class CourseStateCreated extends CourseState {
  final Course course;
  const CourseStateCreated({required this.course});

  @override
  List<Object> get props => [course];
}

class CourseStateUpdated extends CourseState {
  final Course course;
  const CourseStateUpdated({required this.course});

  @override
  List<Object> get props => [course];
}

class CourseStateDeleted extends CourseState {
  const CourseStateDeleted();

  @override
  List<Object> get props => [];
}


// all all state but using for admin

class CourseStateAdminListLoaded extends CourseState {
  final List<Course> courses;
  const CourseStateAdminListLoaded({required this.courses});

  @override
  List<Object> get props => [courses];
}

class CourseStateAdminLoaded extends CourseState {
  final Course course;
  const CourseStateAdminLoaded({required this.course});

  @override
  List<Object> get props => [course];
}

class CourseStateAdminError extends CourseState {
  final String message;
  const CourseStateAdminError({required this.message});

  @override
  List<Object> get props => [message];
}

