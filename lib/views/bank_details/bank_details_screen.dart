import 'package:executive/config/session_manager/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bank_bloc/bank_bloc.dart';
import '../../bloc/bank_bloc/bank_event.dart';
import '../../bloc/bank_bloc/bank_state.dart';
import '../../config/colors/app_colors.dart';
import '../../model/bank_model/bank_model.dart';

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});

  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {

  @override
  void initState() {
    context.read<BankBloc>().add(FetchBanks());
    super.initState();
  }

  void _showMsg(String msg, {Color bgColor = Colors.grey}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: bgColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Text(msg, style: const TextStyle(color: Colors.white)),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Bank Details",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      ///  LISTENER FOR SUCCESS / ERROR
      body: BlocListener<BankBloc, BankState>(
        listener: (context, state) {
          if (state is BankError) {
            _showMsg(state.message, bgColor: Colors.red);
          } else if (state is BankSuccess) {
            _showMsg("Bank Details Added", bgColor: Colors.green);
          }
        },

        child: BlocBuilder<BankBloc, BankState>(
          builder: (context, state) {

            if (state is BankLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is BankLoaded) {
              if (state.banks.isEmpty) {
                return const Center(child: Text("No Bank Details Found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.banks.length,
                itemBuilder: (_, i) {
                  final bank = state.banks[i];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// 🔹 HEADER
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                bank.accountName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _openBottomSheet(bank: bank),
                              )
                            ],
                          ),

                          const SizedBox(height: 10),

                          _buildField("Bank Name", bank.bankName),
                          _buildField("Branch", bank.branchName ?? "-"),
                          _buildField("Account Number", bank.accountNumber),
                          _buildField("IFSC Code", bank.ifscCode),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            if (state is BankError) {
              return Center(child: Text(state.message));
            }

            return const SizedBox();
          },
        ),
      ),

      /// ✅ FAB FOR ADD
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openBottomSheet(),
        icon: const Icon(Icons.add),
        label: const Text("Add Bank"),
      ),
    );
  }

  /// 🔹 FIELD UI
  Widget _buildField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _openBottomSheet({BankModel? bank}) async {

    final name = TextEditingController(text: bank?.accountName);
    final accNo = TextEditingController(text: bank?.accountNumber);
    final ifsc = TextEditingController(text: bank?.ifscCode);
    final bankName = TextEditingController(text: bank?.bankName);
    final branch = TextEditingController(text: bank?.branchName);

    final userId = await SessionManager.getUserId();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Header with Title + Cancel Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      bank == null ? "Add Bank Details" : "Update Bank Details",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Input Fields
                _input("Account Holder Name", name),
                _input("Account Number", accNo),
                _input("IFSC Code", ifsc),
                _input("Bank Name", bankName),
                _input("Branch Name", branch),

                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue, // Blue background
                      foregroundColor: Colors.white, // White text
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Radius 10
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {

                      if (name.text.isEmpty ||
                          accNo.text.isEmpty ||
                          ifsc.text.isEmpty) {
                        _showMsg("Please fill all required fields",
                            bgColor: Colors.red);
                        return;
                      }

                      final body = {
                        "user_id": userId,
                        "account_name": name.text,
                        "account_number": accNo.text,
                        "ifsc_code": ifsc.text,
                        "bank_name": bankName.text,
                        "account_type": "savings",
                        "branch_name": branch.text,
                      };

                      if (bank == null) {
                        context.read<BankBloc>().add(AddBank(body));
                      } else {
                        context.read<BankBloc>().add(
                            UpdateBank(bank.id, body));
                      }

                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
