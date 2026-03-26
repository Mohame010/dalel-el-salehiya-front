import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ScheduledNotificationsScreen extends StatefulWidget {
  @override
  State<ScheduledNotificationsScreen> createState() =>
      _ScheduledNotificationsScreenState();
}

class _ScheduledNotificationsScreenState
    extends State<ScheduledNotificationsScreen> {

  List data = [];
  bool loading = true;

  Future fetch() async {
    final all = await ApiService.get("/notifications-history");

    setState(() {
      data =
          all.where((n) => n["status"] == "scheduled").toList();
      loading = false;
    });
  }

  Future delete(int id) async {
    await ApiService.delete("/delete-notification/$id");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted 🔥")),
    );

    fetch();
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text("Delete?", style: TextStyle(color: Colors.white)),
        content: Text("Are you sure?",
            style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              delete(id);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
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
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Scheduled ⏳",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: loading
                    ? Center(child: CircularProgressIndicator())
                    : data.isEmpty
                        ? Center(
                            child: Text(
                              "No Scheduled Notifications 😢",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final n = data[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    color:
                                        Colors.white.withOpacity(0.1),
                                    border: Border.all(
                                        color: Colors.white24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(

                                    title: Text(
                                      n["title"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              FontWeight.bold),
                                    ),

                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          "📅 ${n["scheduled_at"]}",
                                          style: TextStyle(
                                              color: Colors.white70),
                                        ),
                                        Text(
                                          "Status: ${n["status"]}",
                                          style: TextStyle(
                                              color: Colors.orange),
                                        ),
                                      ],
                                    ),

                                    trailing: IconButton(
                                      icon: Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          confirmDelete(n["id"]),
                                    ),
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

  BoxDecoration gradient() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xff0f2027),
          Color(0xff203a43),
          Color(0xff2c5364),
        ],
      ),
    );
  }
}
