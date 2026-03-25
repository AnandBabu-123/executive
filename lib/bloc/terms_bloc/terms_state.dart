import '../../model/content_model/content_model.dart';

abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsLoaded extends TermsState {
  final ContentModel data;
  TermsLoaded(this.data);
}

class TermsError extends TermsState {
  final String message;
  TermsError(this.message);
}