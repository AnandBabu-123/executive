abstract class WalletEvent {}

class FetchWallet extends WalletEvent {}
class LoadMoreWallet extends WalletEvent {}

class WithdrawWallet extends WalletEvent {
  final String amount;

  WithdrawWallet(this.amount);
}