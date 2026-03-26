import 'package:flutter/material.dart';
import 'notification_settings_screen.dart';
import 'send_notification_screen.dart';
import 'notification_history_screen.dart';
import 'scheduled_notifications_screen.dart';
import '../widgets/app_header.dart';

class NotificationSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 10),
            children: [

              header(),

              buildItem(
                context,
                "Send Notification",
                "Send push notifications instantly",
                Icons.send,
                Colors.blue,
                SendNotificationScreen(),
              ),

              buildItem(
                context,
                "Scheduled Notifications",
                "Manage scheduled messages",
                Icons.schedule,
                Colors.orange,
                ScheduledNotificationsScreen(),
              ),

              buildItem(
                context,
                "History",
                "View sent notifications",
                Icons.history,
                Colors.green,
                NotificationHistoryScreen(),
              ),

              buildItem(
                context,
                "Settings",
                "Configure notification system",
                Icons.settings,
                Colors.purple,
                NotificationSettingsScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 Header محسّن
  Widget header() => Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
          
            SizedBox(width: 10),
            AppHeader(title: "notification 🔔")
            
            
          ],
        ),
      );

  // 🔥 Card محسّن
  Widget buildItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    Widget screen,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => screen));
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
            padding: EdgeInsets.all(16),
            child: Row(
              children: [

                // 🔥 Icon
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
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
                Icon(Icons.arrow_forward_ios,
                    color: Colors.white70, size: 16),
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
