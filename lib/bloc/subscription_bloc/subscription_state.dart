import '../../model/subscription_model/subscription_model.dart';

abstract class SubscriptionState {}

class SubscriptionInitial extends SubscriptionState {}

class SubscriptionLoading extends SubscriptionState {}

class SubscriptionLoaded extends SubscriptionState {
  final List<Subscription> list;
  final int currentPage;
  final int lastPage;

  SubscriptionLoaded({
    required this.list,
    required this.currentPage,
    required this.lastPage,
  });
}

class SubscriptionError extends SubscriptionState {
  final String message;

  SubscriptionError(this.message);
}