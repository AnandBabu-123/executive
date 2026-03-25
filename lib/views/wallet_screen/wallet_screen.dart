import 'package:executive/config/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/wallet_bloc/wallet_bloc.dart';
import '../../bloc/wallet_bloc/wallet_event.dart';
import '../../bloc/wallet_bloc/wallet_state.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<WalletBloc>().add(FetchWallet());

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        context.read<WalletBloc>().add(LoadMoreWallet());
      }
    });
  }

  void _openWithdrawSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),

      /// ✅ FIX: Provide same bloc to bottom sheet
      builder: (_) {
        return BlocProvider.value(
          value: context.read<WalletBloc>(),
          child: const WithdrawBottomSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      /// WITHDRAW BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: _openWithdrawSheet,
            child: const Text("Withdraw"),
          ),
        ),
      ),

      /// BODY
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletWithdrawSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is WalletWithdrawError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WalletError) {
            return Center(child: Text(state.message));
          }

          if (state is WalletLoaded) {
            final result = state.result;

            return Column(
              children: [
                const SizedBox(height: 40),

                /// BALANCE CARD
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text("Current Balance",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(
                        "₹ ${result.summary.currentBalance}",
                        style: const TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _miniItem("Credit",
                              result.summary.totalCredit, Colors.white),
                          _miniItem("Debit",
                              result.summary.totalDebit, Colors.white),
                        ],
                      )
                    ],
                  ),
                ),

                /// TRANSACTIONS
                Expanded(
                  child: state.transactions.isEmpty
                      ? const Center(child: Text("No Transactions"))
                      : ListView.builder(
                    controller: scrollController,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.transactions.length,
                    itemBuilder: (_, i) {
                      final tx = state.transactions[i];
                      final isDebit = tx.debit != "-";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isDebit
                                  ? Colors.red.shade50
                                  : Colors.green.shade50,
                              child: Icon(
                                isDebit
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                color: isDebit
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text("Txn ID: ${tx.transactionId}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  Text("${tx.date} • ${tx.time}",
                                      style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12)),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Text(
                                  isDebit
                                      ? "- ₹${tx.debit}"
                                      : "+ ₹${tx.credit}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDebit
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(tx.status),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
class WithdrawBottomSheet extends StatefulWidget {
  const WithdrawBottomSheet({super.key});

  @override
  State<WithdrawBottomSheet> createState() => _WithdrawBottomSheetState();
}

class _WithdrawBottomSheetState extends State<WithdrawBottomSheet> {
  final TextEditingController amountController = TextEditingController();

  String? error;

  void _showError(String msg) {
    setState(() => error = msg);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => error = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletWithdrawSuccess) {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );

            context.read<WalletBloc>().add(FetchWallet()); // refresh
          }

          if (state is WalletWithdrawError) {
            _showError(state.message);
          }
        },
        builder: (context, state) {
          final loading = state is WalletWithdrawing;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Withdraw Amount",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// ERROR MESSAGE
              if (error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: loading
                      ? null
                      : () {
                    final amount =
                    double.tryParse(amountController.text);

                    if (amountController.text.isEmpty) {
                      _showError("Enter amount");
                      return;
                    }

                    if (amount == null || amount <= 0) {
                      _showError("Invalid amount");
                      return;
                    }

                    context
                        .read<WalletBloc>()
                        .add(WithdrawWallet(amount.toString()));
                  },
                  child: loading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text("Submit"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _miniItem(String title, int value, Color color) {
  return Column(
    children: [
      Text(title, style: TextStyle(color: color)),
      const SizedBox(height: 4),
      Text(
        "₹ $value",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
