import '../../model/content_model/content_model.dart';

abstract class PrivacyState {}

class PrivacyInitial extends PrivacyState {}

class PrivacyLoading extends PrivacyState {}

class PrivacyLoaded extends PrivacyState {
  final ContentModel data;
  PrivacyLoaded(this.data);
}

class PrivacyError extends PrivacyState {
  final String message;
  PrivacyError(this.message);
}