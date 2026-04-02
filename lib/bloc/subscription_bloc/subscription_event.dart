abstract class SubscriptionEvent {}

class FetchSubscriptions extends SubscriptionEvent {
  final bool reset;

  FetchSubscriptions({this.reset = false});
}