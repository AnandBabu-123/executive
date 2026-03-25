import 'package:bloc/bloc.dart';
import 'package:executive/bloc/privacy_bloc/privacy_event.dart';
import 'package:executive/bloc/privacy_bloc/privacy_state.dart';

import '../../repository/about_repo/privacy_repository.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  final PrivacyRepository repository;

  PrivacyBloc({required this.repository}) : super(PrivacyInitial()) {
    on<FetchPrivacy>((event, emit) async {
      emit(PrivacyLoading());
      try {
        final data = await repository.getPrivacy();
        emit(PrivacyLoaded(data));
      } catch (e) {
        emit(PrivacyError(e.toString()));
      }
    });
  }
}