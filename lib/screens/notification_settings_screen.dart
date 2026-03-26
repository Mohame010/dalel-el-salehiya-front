import 'package:flutter/material.dart';
import '../services/api_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {

  TextEditingController appId = TextEditingController();
  TextEditingController apiKey = TextEditingController();

  bool loading = false;

  Future load() async {
    final data = await ApiService.get("/settings");

    setState(() {
      appId.text = data["onesignal_app_id"] ?? "";
      apiKey.text = data["onesignal_api_key"] ?? "";
    });
  }

  Future save() async {

    if (appId.text.isEmpty || apiKey.text.isEmpty) {
      showMsg("Fill all fields ❌");
      return;
    }

    setState(() => loading = true);

    try {
      await ApiService.post(
        "/save-settings",
        {
          "appId": appId.text,
          "apiKey": apiKey.text,
        },
      );

      showMsg("Saved Successfully ✅");

    } catch (e) {
      showMsg("Error 💀");
    }

    setState(() => loading = false);
  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔥 Header
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Notification Settings ⚙️",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // 🔥 Info Card محسّنة
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.white70),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Enter your OneSignal App ID and REST API Key.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                buildInput(appId, "OneSignal App ID"),
                buildInput(apiKey, "REST API Key"),

                SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : save,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: loading
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text("Save Settings 💾"),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInput(c, label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
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
