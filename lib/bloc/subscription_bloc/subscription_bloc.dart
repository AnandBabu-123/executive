import 'package:bloc/bloc.dart';
import 'package:executive/bloc/subscription_bloc/subscription_event.dart';
import 'package:executive/bloc/subscription_bloc/subscription_state.dart';

import '../../model/subscription_model/subscription_model.dart';
import '../../repository/subscriptions_repository/subscriptions_repository.dart';

class SubscriptionBloc
    extends Bloc<SubscriptionEvent, SubscriptionState> {

  final SubscriptionsRepository subscriptionsRepository;

  List<Subscription> subscriptions = [];
  int currentPage = 1;
  int lastPage = 1;
  bool isFetching = false;

  SubscriptionBloc({
    required this.subscriptionsRepository,
  }) : super(SubscriptionInitial()) {

    /// ================= FETCH =================
    on<FetchSubscriptions>((event, emit) async {
      try {
        /// 🔥 STOP if already fetching OR reached last page
        if (isFetching || currentPage > lastPage) return;

        isFetching = true;

        /// 🔥 RESET CASE
        if (event.reset) {
          currentPage = 1;
          lastPage = 1;
          subscriptions.clear();
        }

        /// 🔥 SHOW LOADER ONLY FIRST TIME
        if (subscriptions.isEmpty) {
          emit(SubscriptionLoading());
        }

        final response = await subscriptionsRepository.getSubscriptions(
          page: currentPage,
        );

        /// 🔥 HANDLE EMPTY RESPONSE SAFELY
        if (response.data.isEmpty && subscriptions.isEmpty) {
          emit(SubscriptionError("No Data Found"));
          isFetching = false;
          return;
        }

        /// 🔥 APPEND DATA
        subscriptions.addAll(response.data);

        /// 🔥 UPDATE PAGINATION
        currentPage = response.currentPage + 1;
        lastPage = response.lastPage;

        /// 🔥 EMIT SUCCESS
        emit(SubscriptionLoaded(
          list: List.from(subscriptions),
          currentPage: currentPage,
          lastPage: lastPage,
        ));

      } catch (e) {
        emit(SubscriptionError(e.toString()));
      } finally {
        /// 🔥 ALWAYS RESET FLAG
        isFetching = false;
      }
    });
  }
}