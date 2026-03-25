import 'package:bloc/bloc.dart';
import 'package:executive/bloc/terms_bloc/terms_event.dart';
import 'package:executive/bloc/terms_bloc/terms_state.dart';

import '../../repository/about_repo/terms_repository.dart';

class TermsBloc extends Bloc<TermsEvent, TermsState> {
  final TermsRepository repository;

  TermsBloc({required this.repository}) : super(TermsInitial()) {
    on<FetchTerms>((event, emit) async {
      emit(TermsLoading());
      try {
        final data = await repository.getTerms();
        emit(TermsLoaded(data));
      } catch (e) {
        emit(TermsError(e.toString()));
      }
    });
  }
}