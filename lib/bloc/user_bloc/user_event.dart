import 'dart:io';

abstract class UserEvent {}

class FetchUsers extends UserEvent {
  final bool reset;
  final String? search;
  FetchUsers({this.reset = false, this.search});
}

class AddUser extends UserEvent {
  final String name, email, mobile, gender, dob;
  final int bloodGroupId, coverageCategoryId, userId;
  final File? image;

  AddUser({
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.dob,
    required this.bloodGroupId,
    required this.coverageCategoryId,
    required this.userId,
    this.image,
  });
}