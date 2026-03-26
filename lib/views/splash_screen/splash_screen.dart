import 'package:executive/config/session_manager/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/routes/routes_name.dart';


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

    /// 🔥 Check login after delay
    _checkLogin();
  }
  void _checkLogin() async {
    await Future.delayed(const Duration(seconds: 3));

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


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

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
    );
  }
}
