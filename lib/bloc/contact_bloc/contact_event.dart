abstract class ContactEvent {}

class SubmitContactEvent extends ContactEvent {
  final String name;
  final String email;
  final String mobile;
  final String message;

  SubmitContactEvent({
    required this.name,
    required this.email,
    required this.mobile,
    required this.message,
  });
}