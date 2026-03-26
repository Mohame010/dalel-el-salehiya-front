import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SendNotificationScreen extends StatefulWidget {
  @override
  State<SendNotificationScreen> createState() =>
      _SendNotificationScreenState();
}

class _SendNotificationScreenState
    extends State<SendNotificationScreen> {

  TextEditingController title = TextEditingController();
  TextEditingController message = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController url = TextEditingController();
  TextEditingController schedule = TextEditingController();

  String openType = "app";

  bool loading = false;
  int recipients = 0;

  Future send() async {

    if (title.text.isEmpty || message.text.isEmpty) {
      showMsg("Title & Message required ❌");
      return;
    }

    setState(() => loading = true);

    try {
      final data = await ApiService.post(
        "/send-notification",
        {
          "title": title.text,
          "message": message.text,
          "image": image.text,
          "url": url.text,
          "openType": openType,
          "schedule":
              schedule.text.isEmpty ? null : schedule.text,
        },
      );

      setState(() {
        recipients = data["recipients"] ?? 0;
      });

      showMsg("Sent 🔥");

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [

                Text(
                  "Send Notification 🚀",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 20),

                input(title, "Title"),
                input(message, "Message"),
                input(image, "Image URL"),
                input(url, "Open URL"),
                input(schedule, "Schedule (optional)"),

                SizedBox(height: 10),

                // 🔥 Dropdown محسّن
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: openType,
                      dropdownColor: Colors.black,
                      isExpanded: true,
                      style: TextStyle(color: Colors.white),
                      items: [
                        DropdownMenuItem(
                          value: "app",
                          child: Text("Open App"),
                        ),
                        DropdownMenuItem(
                          value: "link",
                          child: Text("Open Link"),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => openType = v.toString()),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : send,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    child: loading
                        ? CircularProgressIndicator(
                            color: Colors.black)
                        : Text("Send"),
                  ),
                ),

                SizedBox(height: 15),

                if (recipients > 0)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Sent to $recipients users 🔥",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget input(c, l) => Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: l,
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
