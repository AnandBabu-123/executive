import 'package:bloc/bloc.dart';

import '../../repository/bank_details_repository/add_bank_repository.dart';
import '../../repository/bank_details_repository/bank_details_repository.dart';
import '../../repository/bank_details_repository/update_bank_repository.dart';
import 'bank_event.dart';
import 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankDetailsRepository getRepo;
  final AddBankRepository addRepo;
  final UpdateBankRepository updateRepo;

  BankBloc(this.getRepo, this.addRepo, this.updateRepo)
      : super(BankInitial()) {

    on<FetchBanks>((event, emit) async {
      emit(BankLoading());
      try {
        final data = await getRepo.getBankDetails();
        emit(BankLoaded(data));
      } catch (e) {
        emit(BankError(e.toString()));
      }
    });

    on<AddBank>((event, emit) async {
      emit(BankLoading());
      try {
        await addRepo.addBankDetails(event.body);
        emit(BankSuccess());
        add(FetchBanks());
      } catch (e) {
        emit(BankError(e.toString()));
      }
    });

    on<UpdateBank>((event, emit) async {
      emit(BankLoading());
      try {
        await updateRepo.updateBankDetails(event.id, event.body);
        emit(BankSuccess());
        add(FetchBanks());
      } catch (e) {
        emit(BankError(e.toString()));
      }
    });
  }
}