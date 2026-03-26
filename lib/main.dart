import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token") != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: ThemeData(
    fontFamily: "Cairo",),

      debugShowCheckedModeBanner: false,

      // 🔥 مهم جدًا
      navigatorObservers: [MyNavigatorObserver()],

      home: FutureBuilder(
        future: checkLogin(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return MainScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}

// 🔥 Navigator Observer
class MyNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    debugPrint("➡️ Navigated to: ${route.settings.name}");
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugPrint("⬅️ Back to: ${previousRoute?.settings.name}");
  }
}
