import 'package:executive/bloc/update_bloc/update_event.dart';
import 'package:executive/bloc/update_bloc/update_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/update_repository/update_repository.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UpdateRepository repository;

  UpdateBloc(this.repository) : super(UpdateInitial()) {
    on<CheckUpdateEvent>(_checkUpdate);
  }

  Future<void> _checkUpdate(
      CheckUpdateEvent event,
      Emitter<UpdateState> emit,
      ) async {
    emit(UpdateLoading());

    try {
      final response = await repository.getUpdateApi();

      /// 🔴 FORCE UPDATE (older version)
      if (response.status == 426) {
        emit(UpdateRequired(response.result!));
      }

      /// 🟢 ALLOW APP (same OR newer version)
      else if (response.status == 200 &&
          response.result != null &&
          response.result!.compatible == true) {

        emit(UpdateNotRequired());
      }

      /// ⚠️ Unexpected case
      else {
        emit(UpdateError(response.message));
      }

    } catch (e) {
      emit(UpdateError(e.toString()));
    }
  }
}