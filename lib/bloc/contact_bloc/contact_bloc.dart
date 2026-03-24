import 'package:bloc/bloc.dart';

import '../../repository/contact_repo/conatctus_repository.dart';
import 'conatct_state.dart';
import 'contact_event.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final ContactUsRepository repository;

  ContactBloc(this.repository) : super(ContactInitial()) {
    on<SubmitContactEvent>(_onSubmit);
  }

  Future<void> _onSubmit(
      SubmitContactEvent event,
      Emitter<ContactState> emit,
      ) async {
    emit(ContactLoading());

    try {
      final response = await repository.contactUs(
        name: event.name,
        email: event.email,
        mobile: event.mobile,
        message: event.message,
      );

      emit(ContactSuccess(response.message));
    } catch (e) {
      emit(ContactError(e.toString()));
    }
  }
}