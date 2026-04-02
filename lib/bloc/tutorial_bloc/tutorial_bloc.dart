import 'package:bloc/bloc.dart';
import 'package:executive/bloc/tutorial_bloc/tutorial_event.dart';
import 'package:executive/bloc/tutorial_bloc/tutorial_state.dart';

import '../../repository/tutorial_repository/tutorial_repository.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final TutorialRepository repository;

  TutorialBloc(this.repository) : super(TutorialInitial()) {
    on<FetchTutorials>((event, emit) async {
      emit(TutorialLoading());

      try {
        final response = await repository.getTutorials();

        emit(TutorialLoaded(response.tutorials));
      } catch (e) {
        emit(TutorialError(e.toString()));
      }
    });
  }
}