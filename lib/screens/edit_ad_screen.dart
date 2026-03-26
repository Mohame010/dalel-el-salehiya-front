import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditAdScreen extends StatefulWidget {
  final Map ad;

  EditAdScreen({required this.ad});

  @override
  State<EditAdScreen> createState() => _EditAdScreenState();
}

class _EditAdScreenState extends State<EditAdScreen> {

  TextEditingController linkController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    linkController.text = widget.ad["link"];
  }

  // 🔥 UPDATE باستخدام ApiService
  Future updateAd() async {
    setState(() => isLoading = true);

    try {
      await ApiService.put(
        "/update-ad/${widget.ad["id"]}",
        {
          "link": linkController.text,
        },
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Updated Successfully 🔥")),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error 💀")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Ad"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff0f2027),
              Color(0xff203a43),
              Color(0xff2c5364),
            ],
          ),
        ),
        child: Column(
          children: [

            // 🔥 Input
            TextField(
              controller: linkController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Ad Link",
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

            SizedBox(height: 30),

            // 🔥 Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateAd,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.black)
                    : Text(
                        "Update",
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}