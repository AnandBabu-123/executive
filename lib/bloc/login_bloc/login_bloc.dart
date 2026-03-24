import '../../repository/login_repo/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>(_onLogin);
  }

  Future<void> _onLogin(
      LoginButtonPressed event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());

    try {
      final response = await repository.login(
        phone: event.phone,
      );

      emit(LoginSuccess(response));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}