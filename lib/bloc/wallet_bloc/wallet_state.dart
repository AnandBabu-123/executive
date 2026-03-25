import '../../model/wallet_model/wallet_model.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoaded extends WalletState {
  final WalletResult result;
  final List<TransactionModel> transactions;
  final int currentPage;
  final int lastPage;

  WalletLoaded({
    required this.result,
    required this.transactions,
    required this.currentPage,
    required this.lastPage,
  });
}

class WalletError extends WalletState {
  final String message;
  WalletError(this.message);
}

class WalletWithdrawing extends WalletState {}

class WalletWithdrawSuccess extends WalletState {
  final String message;
  WalletWithdrawSuccess(this.message);
}

class WalletWithdrawError extends WalletState {
  final String message;
  WalletWithdrawError(this.message);
}