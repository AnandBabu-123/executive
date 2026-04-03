import 'package:executive/config/session_manager/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../bloc/update_bloc/update_bloc.dart';
import '../../bloc/update_bloc/update_event.dart';
import '../../bloc/update_bloc/update_state.dart';
import '../../config/routes/routes_name.dart';


import 'package:executive/config/session_manager/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/routes/routes_name.dart';
import '../../model/update_response/update_response.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.repeat(reverse: true);

    /// 🔥 CALL UPDATE API (instead of direct login)
    context.read<UpdateBloc>().add(CheckUpdateEvent());
  }

  /// ✅ LOGIN FLOW (same as your code)
  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await SessionManager.getToken();

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(
        context,
        RoutesName.homeScreen,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        RoutesName.loginScreen,
      );
    }
  }

  /// 🔴 FORCE UPDATE DIALOG
  void _showUpdateDialog(UpdateResult result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Update Required"),
          content: Text(result.message),
          actions: [
            TextButton(
              onPressed: () {
                // 👉 Add Play Store link here
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<UpdateBloc, UpdateState>(
      listener: (context, state) {

        /// 🔴 If update required → block app
        if (state is UpdateRequired) {
          _showUpdateDialog(state.result);
        }

        /// ✅ If no update → continue login
        else if (state is UpdateNotRequired) {
          _checkLogin();
        }

        /// ⚠️ If error → allow login anyway
        else if (state is UpdateError) {
          _checkLogin();
        }
      },

      child: Scaffold(
        body: Center(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.scale(
                scale: _animation.value,
                child: SvgPicture.asset(
                  "assets/med.svg",
                  height: 120,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
