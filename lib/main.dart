
import 'package:flutter/material.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Executive',

      ///  START FROM SPLASH
      initialRoute: RoutesName.splashScreen,

      onGenerateRoute: Routes.generateRoute,
    );
  }
}

