import 'package:executive/config/colors/app_colors.dart';
import 'package:executive/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/session_manager/session_manager.dart';
import '../subscription_screen/subscription_screen.dart';
import 'app_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  String name = "";
  String type ="";

  @override void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userName = await SessionManager.getName();
    final userType = await SessionManager.getType();

    setState(() {
      name = userName ?? "";
      type = userType ?? "";

    }); }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

     drawer: AppDrawer(rootContext: context),
      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0,

        leading: Builder( builder: (context)
        { return IconButton( icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () { Scaffold.of(context).openDrawer();
          },
        ); },
        ),

        title: SvgPicture.asset(
          "assets/logo.svg",
          height: 28,
        ),

        actions: const [
          Padding(
            padding:  EdgeInsets.only(right: 16),
            child: CircleAvatar( backgroundColor: Colors.white, radius: 18,
              child:  Icon( Icons.notifications, color: AppColors.blue, size: 20,
              ), ), ),
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
                        fontSize: 16,
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
                            Colors.orange,
                          onTap: () {
                            Navigator.pushNamed(context, RoutesName.userScreen);
                          },),

                        /// ✅ SHOW ONLY IF NOT AGENT
                        if (type != "Agent")
                          _buildStatCard(
                            "Agents",
                            "20,300",
                            Colors.blue.shade600,
                            onTap: () {
                              Navigator.pushNamed(context, RoutesName.agentScreen);
                            },
                          ),

                        _buildStatCard("Tutorials", "20",
                            Colors.lightGreen),

                        _buildStatCard("Wallet Balance", "20,300",
                            Colors.deepOrange, onTap: () {
                              Navigator.pushNamed(context, RoutesName.walletScreen);
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),


            const SizedBox(height: 20),

            /// 🔷 RECENT PAYMENTS
            _sectionTitle("Recent Payments"),


            _paymentTile("12", "APR", "Ajay Kumar", "₹2,358", "Completed"),
            _paymentTile("25", "MAR", "Sita Rao", "₹1,414", "Pending"),

            const SizedBox(height: 20),
          ],
        ),
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
  Widget _paymentTile(
      String day,
      String month,
      String name,
      String amount,
      String status,
      ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5)
        ],
      ),
      child: Row(
        children: [

          /// 🔷 LEFT DATE BOX (like camp card)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  month,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// 🔷 NAME + TIME
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "11:23 AM",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          /// 🔷 RIGHT SIDE (Amount + Status)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: status == "Completed"
                      ? Colors.green
                      : Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}