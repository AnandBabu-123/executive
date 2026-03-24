abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String phone;

  LoginButtonPressed(this.phone);
}