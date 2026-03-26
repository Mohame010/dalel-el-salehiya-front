import 'package:dalel_dashboard/screens/users_admin_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'items_section.dart';
import 'categories_section.dart';
import 'ads_section.dart';
import 'places_section.dart';
import 'notification_section.dart';

class HomeScreen extends StatelessWidget {
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
child: SafeArea(
child: Column(
children: [
          // 🔥 Header
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dashboard 🚀",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Manage System Dalel-El-Salehiya",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();

                    await prefs.clear();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                      (route) => false,
                    );
                  },
                ),

              ],
            ),
          ),

          // 🔥 Grid Sections
          Expanded(
            child: GridView.count(
              crossAxisCount:
                  MediaQuery.of(context).size.width < 800 ? 2 : 5,
              padding: EdgeInsets.all(15),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [

                buildCard(context, "Categories", Icons.category, Colors.blue, CategoriesSection()),
                buildCard(context, "Users", Icons.people, Colors.orange, UsersAdminScreen()),
                buildCard(context, "Places", Icons.store, Colors.green, PlacesSection()),
                buildCard(context, "Items", Icons.fastfood, Colors.purple, ItemsSection()),
                buildCard(context, "Ads", Icons.campaign, Colors.red, AdsSection()),
                buildCard(context, "Notifications", Icons.notifications_active, Colors.teal, NotificationSection()),

              ],
            ),
          ),
        ],
      ),
    ),
  ),
);
}

// 🔥 Card Widget (FIXED)
Widget buildCard(
BuildContext context,
String title,
IconData icon,
Color color,
Widget screen,
) {
return GestureDetector(
onTap: () {
Navigator.push(
context,
MaterialPageRoute(builder: (_) => screen),
);
},
child: Container(
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(20),
gradient: LinearGradient(
colors: [
Colors.white.withOpacity(0.15),
Colors.white.withOpacity(0.05),
],
),
border: Border.all(color: Colors.white24),
),
child: Padding(
padding: EdgeInsets.all(12),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
mainAxisSize: MainAxisSize.min,
children: [

          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),

          SizedBox(height: 8),

          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    ),
  ),
);
}
}
