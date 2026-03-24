import 'package:executive/config/colors/app_colors.dart';
import 'package:flutter/material.dart';


class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int? selectedAmount;

  final List<int> amounts = [500, 2500, 5000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Wallet", style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),),
        centerTitle: true,
      ),

      /// ================= BODY =================
      body: Column(
        children: [
      SizedBox(height: 20,),
          ///  TOP RED CONTAINER (WALLET BALANCE)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 140,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, // optional for vertical center
                children: const [
                  Text(
                    "Wallet Balance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "₹10,000",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// ⚪ WHITE CONTAINER (WITHDRAW OPTIONS)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.grey.shade300,
                )
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Select Withdraw Amount",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                /// ROW OF AMOUNTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: amounts.map((amount) {
                    final isSelected = selectedAmount == amount;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAmount = amount;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.red : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "₹$amount",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),

      /// 🔘 BOTTOM BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: selectedAmount == null
                ? null
                : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Withdraw ₹$selectedAmount clicked"),
                ),
              );
            },
            child: const Text(
              "Withdraw",
              style: TextStyle(
                fontSize: 16,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
