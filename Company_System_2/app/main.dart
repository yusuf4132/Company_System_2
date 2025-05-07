import 'package:company_system_2/loginpage/login_page.dart';
import 'package:company_system_2/registerpage/register_page.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const HomeApplication());
}

class HomeApplication extends StatelessWidget {
  const HomeApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPages(),
        '/register': (context) => RegisterPages(),
      },
    );
  }
}
