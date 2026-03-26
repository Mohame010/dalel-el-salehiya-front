import 'package:dalel_dashboard/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'categories_section.dart';
import 'ads_section.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    CategoriesSection(),
    AdsSection(),
  ];

  @override
  void initState() {
    super.initState();
    checkAdmin();
  }

  Future checkAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString("role");

    if (role != "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      // 🔥 Bottom Navigation محسّن
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color(0xff0f2027),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          backgroundColor: Color(0xff0f2027),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Categories",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.campaign),
              label: "Ads",
            ),
          ],
        ),
      ),
    );
  }
}
