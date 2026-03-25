import 'package:executive/config/colors/app_colors.dart';
import 'package:executive/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/session_manager/session_manager.dart';
import '../subscription_screen/subscription_screen.dart';
import 'app_drawer.dart';



import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  String name = "Uday";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(), // your drawer

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0,

        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),

        title: SvgPicture.asset(
          "assets/logo.svg",
          height: 28,
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/userLogo.png",),
            ),
          )
        ],
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: 20,),

            /// 🔷 TOP GRADIENT HEADER
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade900,
                      Colors.blue.shade500,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 10),

                    Text(
                      "Welcome, $name!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// 🔷 STATS GRID
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.8,
                      children: [

                        _buildStatCard(
                          "Total Subscriptions",
                          "125",
                          Colors.blue.shade400,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SubscriptionScreen(),
                              ),
                            );
                          },
                        ),
                        _buildStatCard(
                            "Monthly Earnings", "8", Colors.blue.shade700),

                        _buildStatCard("Users", "45,600",
                            Colors.orange),

                        _buildStatCard("Agents", "20,300",
                            Colors.blue.shade600),

                        _buildStatCard("Notifications", "20,300",
                            Colors.lightGreen),

                        _buildStatCard("Wallet Balance", "20,300",
                            Colors.deepOrange),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔷 UPCOMING CAMPS
            _sectionTitle("Upcoming Camps"),

            _campCard("12", "Pagolu Health Camp", "12 Apr 2026", "56"),
            _campCard("25", "Machilipatnam Camp", "25 Mar 2026", "30"),

            const SizedBox(height: 20),

            /// 🔷 RECENT PAYMENTS
            _sectionTitle("Recent Payments"),

            _paymentTile("Ajay Kumar", "₹2,358", "Completed"),
            _paymentTile("Sita Rao", "₹1,414", "Pending"),

            const SizedBox(height: 20),
          ],
        ),
      ),

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          setState(() {
            currentIndex = i;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), label: "Tasks"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Users"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Agents"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// ================= STAT CARD =================
  Widget _buildStatCard(
      String title,
      String value,
      Color color, {
        VoidCallback? onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold,),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14)
        ],
      ),
    );
  }

  /// ================= CAMP CARD =================
  Widget _campCard(
      String day, String title, String date, String registrations) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(day,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const Text("DEC",
                    style: TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          Text("$registrations Registrations",
              style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  /// ================= PAYMENT TILE =================
  Widget _paymentTile(String name, String amount, String status) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage("assets/icon.png"),
      ),
      title: Text(name),
      subtitle: const Text("11:23 AM"),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(amount,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: status == "Completed"
                  ? Colors.orange
                  : Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(status,
                style: const TextStyle(
                    color: Colors.white, fontSize: 10)),
          )
        ],
      ),
    );
  }
}