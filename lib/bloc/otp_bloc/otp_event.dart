abstract class OtpEvent {}

class SubmitOtpEvent extends OtpEvent {
  final int userId;
  final String otp;

  SubmitOtpEvent({
    required this.userId,
    required this.otp,
  });
}