import '../../model/bank_model/bank_model.dart';

abstract class BankState {}

class BankInitial extends BankState {}

class BankLoading extends BankState {}

class BankLoaded extends BankState {
  final List<BankModel> banks;
  BankLoaded(this.banks);
}

class BankError extends BankState {
  final String message;
  BankError(this.message);
}

class BankSuccess extends BankState {}