import '../../model/user_model/user_model.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final int currentPage;
  final int lastPage;
  UserLoaded({required this.users, required this.currentPage, required this.lastPage});
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}

class UserAdding extends UserState {}

class UserAdded extends UserState {}

class UserAddError extends UserState {
  final String message;
  UserAddError(this.message);
}