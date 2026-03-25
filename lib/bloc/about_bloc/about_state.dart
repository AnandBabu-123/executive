import '../../model/about_model/about_model.dart';

abstract class AboutState {}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  final AboutModel about;

  AboutLoaded(this.about);
}

class AboutError extends AboutState {
  final String message;

  AboutError(this.message);
}