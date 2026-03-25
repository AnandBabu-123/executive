import 'package:executive/config/routes/routes_name.dart';
import 'package:flutter/material.dart';

import '../../config/session_manager/session_manager.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final BuildContext rootContext; // must pass scaffold context
  const AppDrawer({super.key, required this.rootContext});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String name = "";
  String type = "";
  String uniqueCode = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userName = await SessionManager.getName();
    final userType = await SessionManager.getType();
    final uniQueCode = await SessionManager.getUniqueId();
    final userEmail = await SessionManager.getEmail();

    if (!mounted) return; // safety check
    setState(() {
      name = userName ?? "";
      type = userType ?? "";
      uniqueCode = uniQueCode ?? "";
      email = userEmail ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ================= DRAWER HEADER =================
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
            ),
            accountName: Text(
              name.isNotEmpty ? name : "User Name",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
            " Referral Code : ${uniqueCode.isNotEmpty ? uniqueCode : ""}",
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                name.isNotEmpty ? name[0] : "U",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ),

          // ================= DRAWER ITEMS =================
          _drawerItem(
            icon: Icons.person,
            title: "Profile",
            onTap: () {
              Navigator.of(widget.rootContext).pushNamed(RoutesName.profileScreen);
            },
          ),
          _drawerItem(
            icon: Icons.account_balance,
            title: "Bank Details",
            onTap: () {
              Navigator.of(widget.rootContext).pushNamed(RoutesName.bankDetails);
            },
          ),
          _drawerItem(
            icon: Icons.info_outline,
            title: "Contact Us",
            onTap: () {
              Navigator.of(widget.rootContext).pushNamed(RoutesName.contactUsScreen);
            },
          ),

          const Spacer(),
          const Divider(),

          _drawerItem(
            icon: Icons.logout,
            title: "Logout",
            color: Colors.red,
            onTap: () async {
              Navigator.pop(context); // close drawer
              await Future.delayed(const Duration(milliseconds: 250));

              showDialog(
                context: widget.rootContext,
                barrierDismissible: false,
                builder: (dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // rounded dialog
                  ),
                  contentPadding: const EdgeInsets.all(24),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [


                      const Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Are you sure you want to logout?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),

                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Cancel button
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey.shade200,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {
                                Navigator.of(dialogContext).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Logout button
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () async {
                                Navigator.of(dialogContext).pop();
                                await SessionManager.clearSession();
                                if (widget.rootContext.mounted) {
                                  Navigator.of(widget.rootContext).pushNamedAndRemoveUntil(
                                    RoutesName.loginScreen,
                                        (route) => false,
                                  );
                                }
                              },
                              child: const Text(
                                "Logout",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

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