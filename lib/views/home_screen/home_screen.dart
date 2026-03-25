import 'package:executive/config/colors/app_colors.dart';
import 'package:executive/config/routes/routes_name.dart';
import 'package:flutter/material.dart';
import '../../config/session_manager/session_manager.dart';
import 'app_drawer.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isAvailable = true;
  int currentIndex = 0;

  String name = "";
  String type = "";
  String uniqueCode = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userName = await SessionManager.getName();
    final userType = await SessionManager.getType();
    final uniQueCode = await SessionManager.getUniqueId();


    setState(() {
      name = userName ?? "";
      type = userType ?? "";
      uniqueCode = uniQueCode ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// ✅ IMPORTANT: ADD DRAWER HERE
      drawer: AppDrawer(rootContext: context),

      /// ================= APP BAR =================
      appBar: AppBar(
        backgroundColor: AppColors.blue,

        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // ✅ works now
              },
            );
          },
        ),

        title: const Text(
          "DashBoard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
   centerTitle: true,
        actions: [

          /// WALLET ICON
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: const Icon(
                Icons.account_balance_wallet,
                color: AppColors.blue,
                size: 20,
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: const Icon(
                Icons.notifications,
                color: AppColors.blue,
                size: 20,
              ),
            ),
          ),

          /// SWITCH
          // Padding(
          //   padding: const EdgeInsets.only(right: 12),
          //   child: Switch(
          //     value: isAvailable,
          //     activeThumbColor: Colors.white,
          //     onChanged: (value) {
          //       setState(() {
          //         isAvailable = value;
          //       });
          //     },
          //   ),
          // ),
        ],
      ),

      /// ================= BODY =================
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            /// PROFILE ROW
            Row(
              children: [

                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/icon.png"),
                ),

                const SizedBox(width: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [

                    Text(
                      name.isEmpty ? "User" : name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      type.isEmpty ? "Executive" : type,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),

                    Text(
                      uniqueCode,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 40),

            const Text(
              "Progress",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// PROGRESS BAR
            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            /// MENU ROW
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  _buildMenuItem(
                    icon: Icons.person_add,
                    label: "Users",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.agentScreen);
                    },
                  ),

                  _buildMenuItem(
                    icon: Icons.person,
                    label: "Agents",
                    color: Colors.green,
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.userScreen);
                    },
                  ),

                  // _buildMenuItem(
                  //   icon: Icons.notifications,
                  //   label: "Notifications",
                  //   color: Colors.orange,
                  //   onTap: () {},
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),

      // /// ================= BOTTOM NAV =================
      // bottomNavigationBar: BottomNavigationBar(
      //
      //   currentIndex: currentIndex,
      //
      //   onTap: (index) {
      //     setState(() {
      //       currentIndex = index;
      //     });
      //   },
      //
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.grey,
      //
      //   items: const [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Home",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.assignment),
      //       label: "Tasks",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: "Profile",
      //     ),
      //   ],
      // ),
    );
  }

  /// ================= MENU ITEM =================
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),

          const SizedBox(height: 8),

          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}