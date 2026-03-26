import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class AuthGate extends StatefulWidget {
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {

  Widget screen = Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future checkUser() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    String? role = prefs.getString("role");

    if (token != null && role == "admin") {
      setState(() {
        screen = MainScreen(); // 💀 يدخل الداشبورد
      });
    } else {
      setState(() {
        screen = LoginScreen(); // ❌ يرجع للوجين
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return screen;
  }

  
}