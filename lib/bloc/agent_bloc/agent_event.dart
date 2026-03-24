import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class AgentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchAgents extends AgentEvent {
  final String? search;
  final bool reset;

  FetchAgents({this.search, this.reset = false});

  @override
  List<Object?> get props => [search, reset];
}

class AddAgent extends AgentEvent {
  final String name;
  final String email;
  final String mobile;
  final String gender;
  final String dob;
  final String occupation;
  final File? image;
  final int userId;

  AddAgent({
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
    required this.dob,
    required this.occupation,
    this.image,
    required this.userId,
  });

  @override
  List<Object?> get props => [name, email, mobile, gender, dob, occupation, image, userId];
}