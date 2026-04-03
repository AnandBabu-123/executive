import '../../model/update_response/update_response.dart';

abstract class UpdateState {}

class UpdateInitial extends UpdateState {}

class UpdateLoading extends UpdateState {}

class UpdateNotRequired extends UpdateState {}

class UpdateRequired extends UpdateState {
  final UpdateResult result;

  UpdateRequired(this.result);
}

class UpdateError extends UpdateState {
  final String message;

  UpdateError(this.message);
}