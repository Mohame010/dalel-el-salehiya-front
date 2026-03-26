import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  // ✅ Auto Login
  void checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString("token") != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  // ✅ Error
  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // 🔥 LOGIN باستخدام ApiService
  Future login() async {

    if (username.text.trim().isEmpty || password.text.trim().isEmpty) {
      showError("Enter username & password");
      return;
    }

    setState(() => loading = true);

    try {
      final data = await ApiService.post(
        "/login",
        {
          "username": username.text.trim(),
          "password": password.text.trim(),
        },
      );

      if (data["success"]) {

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("token", data["token"]);
        await prefs.setString("username", data["user"]["username"]);

         await prefs.setString("role", data["user"]["role"]);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );

      } else {
        showError("Invalid username or password ❌");
      }

    } catch (e) {
      showError("Network Error ⚠️");
    }

    setState(() => loading = false);
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0f2027),
              Color(0xff203a43),
              Color(0xff2c5364),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(color: Colors.white24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text(
                      "Login 🔐",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 25),

                    buildInput(username, "Username"),
                    buildInput(password, "Password", isPassword: true),

                    SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: loading ? null : login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        child: loading
                            ? CircularProgressIndicator(color: Colors.black)
                            : Text("Login", style: TextStyle(fontSize: 18)),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInput(TextEditingController controller, String label,
      {bool isPassword = false}) {

    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
