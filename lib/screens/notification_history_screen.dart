import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotificationHistoryScreen extends StatefulWidget {
  @override
  State<NotificationHistoryScreen> createState() =>
      _NotificationHistoryScreenState();
}

class _NotificationHistoryScreenState
    extends State<NotificationHistoryScreen> {

  List data = [];
  bool isLoading = true;

  Future fetch() async {
    final res = await ApiService.get("/notifications-history");

    setState(() {
      data = res;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: Column(
            children: [

              // 🔥 Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Notifications History 🔔",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : data.isEmpty
                        ? Center(
                            child: Text(
                              "No Notifications 😢",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.all(10),
                            itemCount: data.length,
                            itemBuilder: (c, i) {
                              final n = data[i];

                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white.withOpacity(0.1),
                                  border: Border.all(color: Colors.white24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(12),

                                  title: Text(
                                    n["title"] ?? "",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  subtitle: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      "👥 ${n["recipients"] ?? 0} • ${n["status"]}",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ),

                                  trailing: Icon(
                                    Icons.notifications,
                                    color: Colors.white70,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
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
