import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool showBackButton;
  const SubscriptionScreen({super.key,this.showBackButton = false});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedTab = 0;

  final List<String> tabs = ["All", "Single", "Family"];

  /// 🔹 Dummy Data
  List<Map<String, dynamic>> allList = List.generate(10, (index) {
    return {
      "name": "User ${index + 1}",
      "plan": index % 2 == 0 ? "Single Plan" : "Family Plan",
      "amount": "₹${1000 + index * 200}",
      "status": index % 2 == 0 ? "Paid" : "Unpaid",
    };
  });

  List<Map<String, dynamic>> singleList = List.generate(10, (index) {
    return {
      "name": "Single User ${index + 1}",
      "plan": "Single Plan",
      "amount": "₹${1200 + index * 150}",
      "status": index % 2 == 0 ? "Paid" : "Unpaid",
    };
  });

  List<Map<String, dynamic>> familyList = List.generate(10, (index) {
    return {
      "name": "Family User ${index + 1}",
      "plan": "Family Plan",
      "amount": "₹${2000 + index * 300}",
      "status": index % 2 == 0 ? "Paid" : "Unpaid",
    };
  });

  List<Map<String, dynamic>> getCurrentList() {
    if (selectedTab == 0) return allList;
    if (selectedTab == 1) return singleList;
    return familyList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// 🔷 APP BAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // ✅ FORCE WHITE ICON
        ),
        leading: widget.showBackButton
            ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        )
            : null,
        title: const Text(
          "Subscriptions",
          style: TextStyle(color: Colors.white),
        ),
      ),

      /// 🔷 BODY
      body: Column(
        children: [

          const SizedBox(height: 10),

          /// 🔷 CUSTOM TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(tabs.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTab == index
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Center(
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                            color: selectedTab == index
                                ? Colors.white
                                : Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔷 LIST
          Expanded(
            child: ListView.builder(
              itemCount: getCurrentList().length,
              itemBuilder: (context, index) {
                final item = getCurrentList()[index];

                return Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      /// 🔷 IMAGE
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage:
                        AssetImage("assets/icon.png"),
                      ),

                      const SizedBox(width: 12),

                      /// 🔷 TEXT DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["name"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["plan"],
                              style: const TextStyle(
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      /// 🔷 AMOUNT + STATUS
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item["amount"],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: item["status"] == "Paid"
                                  ? Colors.green
                                  : Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item["status"],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}