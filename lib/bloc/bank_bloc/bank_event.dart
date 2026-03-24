abstract class BankEvent {}

class FetchBanks extends BankEvent {}

class AddBank extends BankEvent {
  final Map<String, dynamic> body;
  AddBank(this.body);
}

class UpdateBank extends BankEvent {
  final int id;
  final Map<String, dynamic> body;
  UpdateBank(this.id, this.body);
}