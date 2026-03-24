import 'package:bloc/bloc.dart';
import '../../config/session_manager/session_manager.dart';
import '../../repository/otp_repo/otp_repository.dart';
import 'otp_event.dart';
import 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpRepository repository;

  OtpBloc(this.repository) : super(OtpInitial()) {
    on<SubmitOtpEvent>(_verifyOtp);
  }

  Future<void> _verifyOtp(
      SubmitOtpEvent event,
      Emitter<OtpState> emit,
      ) async {
    emit(OtpLoading());

    try {
      final response = await repository.verifyOtp(
        userId: event.userId,
        otp: event.otp,
      );

      /// SAVE USER DATA
      final user = response.result.first;
      await SessionManager.saveUser(user);

      emit(OtpSuccess());
    } catch (e) {
      emit(OtpError(e.toString()));
    }
  }
}