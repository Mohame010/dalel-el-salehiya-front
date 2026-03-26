import 'package:flutter/material.dart';
import 'add_place_screen.dart';
import 'places_admin_screen.dart';
import '../widgets/app_header.dart';

class PlacesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: Column(
            children: [

              // 🔥 Header محسّن
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                  
                    SizedBox(width: 10),
                    AppHeader(title: "Places 🏪"),
                      
                      
                    
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: [

                    buildCard(
                      context,
                      title: "Add Place",
                      subtitle: "Create a new place",
                      icon: Icons.add_location,
                      color: Colors.green,
                      screen: AddPlaceScreen(),
                    ),

                    buildCard(
                      context,
                      title: "View Places",
                      subtitle: "Edit or delete places",
                      icon: Icons.storefront,
                      color: Colors.blue,
                      screen: PlacesAdminScreen(),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
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
            padding: EdgeInsets.all(18),
            child: Row(
              children: [

                // 🔥 Icon
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),

                SizedBox(width: 15),

                // 🔥 Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔥 Arrow
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration gradient() => BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff0f2027),
            Color(0xff203a43),
            Color(0xff2c5364),
          ],
        ),
      );
}
