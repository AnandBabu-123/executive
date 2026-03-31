import 'package:executive/config/colors/app_colors.dart';
import 'package:executive/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../bloc/home_bloc/home_bloc.dart';
import '../../bloc/home_bloc/home_state.dart';
import '../../config/routes/app_url.dart';
import '../../config/session_manager/session_manager.dart';
import '../subscription_screen/subscription_screen.dart';
import 'app_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeScreen({
    super.key,
    required this.scaffoldKey,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  String name = "";
  String type ="";
  String? profileImage;

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

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                widget.scaffoldKey.currentState?.openDrawer();
              },
            );
          },
        ),

        title: SvgPicture.asset(
          "assets/logo.svg",
          height: 28,
        ),

        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(
                Icons.notifications,
                color: AppColors.blue,
                size: 20,
              ),
            ),
          ),

          /// 🔥 PROFILE IMAGE FROM API
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,

              /// ✅ IMAGE LOGIC
              backgroundImage: (profileImage != null &&
                  profileImage!.isNotEmpty)
                  ? NetworkImage(profileImage!)
                  : const AssetImage("assets/userLogo.png")
              as ImageProvider,

              /// ✅ OPTIONAL: fallback if network fails
              onBackgroundImageError: (_, __) {},
            ),
          ),
        ],
      ),

      /// ================= BODY =================
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {

          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeError) {
            return Center(child: Text(state.message));
          }

          if (state is HomeLoaded) {

            final data = state.data;

            /// 🔥 SET PROFILE IMAGE FROM API
            profileImage = (data.image != null && data.image!.isNotEmpty)
                ? "${data.image}"
                : null;

            return SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 20),

                  /// 🔷 HEADER
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
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Welcome, ${data.name}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

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
                                data.totalSubscriptions.toString(),
                                Colors.blue,
                              ),

                              _buildStatCard(
                                "Monthly Earnings",
                                data.monthlyEarnings,
                                Colors.blue.shade700,
                              ),

                              _buildStatCard(
                                "Users",
                                data.users.toString(),
                                Colors.orange,
                              ),

                              if (type != "Agent")
                                _buildStatCard(
                                  "Agents",
                                  data.agents.toString(),
                                  Colors.blue.shade600,
                                ),

                              _buildStatCard(
                                "Tutorials",
                                data.tutorials.toString(),
                                Colors.green,
                              ),

                              _buildStatCard(
                                "Wallet Balance",
                                data.walletBalance,
                                Colors.deepOrange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Recent Payments"),

                  /// 🔥 DYNAMIC PAYMENTS
                  ...data.recentPayments.map((e) {
                    final date = DateTime.parse(e.date);

                    return _paymentTile(
                      date.day.toString(),
                      _getMonth(date.month),
                      e.name,
                      "₹${e.amount}",
                      "Completed",
                    );
                  }).toList(),

                  const SizedBox(height: 20),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),

    );
  }

  String _getMonth(int m) {
    const months = [
      "JAN","FEB","MAR","APR","MAY","JUN",
      "JUL","AUG","SEP","OCT","NOV","DEC"
    ];
    return months[m - 1];
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