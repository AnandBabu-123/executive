import 'package:executive/config/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../../config/session_manager/session_manager.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Column(
        children: [


          SizedBox(height:90 ,),
          _drawerItem(
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              Navigator.pushNamed(context, RoutesName.profileScreen);
            },
          ),

          _drawerItem(
            icon: Icons.account_balance,
            title: "Bank Details",
            onTap: () {
             Navigator.pushNamed(context, RoutesName.bankDetails);
            },
          ),

          _drawerItem(
            icon: Icons.info_outline,
            title: "Contact Us",
            onTap: () {
              Navigator.pushNamed(context, RoutesName.contactUsScreen);
            },
          ),

          const Spacer(),

          const Divider(),

          /// LOGOUT
          _drawerItem(
            icon: Icons.logout,
            title: "Logout",
            color: Colors.red,
            onTap: () {
              Navigator.pop(context); // close drawer

              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext); // close dialog
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () async {
                        /// close dialog first
                        Navigator.pop(dialogContext);

                        await SessionManager.clearSession();

                        if (!context.mounted) return;

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesName.loginScreen,
                              (route) => false,
                        );
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// ================= COMMON ITEM =================
  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}