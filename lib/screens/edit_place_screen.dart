import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditPlaceScreen extends StatefulWidget {
  final Map place;

  EditPlaceScreen({required this.place});

  @override
  State<EditPlaceScreen> createState() => _EditPlaceScreenState();
}

class _EditPlaceScreenState extends State<EditPlaceScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController whatsapp = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    name.text = widget.place["name"];
    address.text = widget.place["address"];
    phone.text = widget.place["phone"];
    whatsapp.text = widget.place["whatsapp"];
  }

  // 🔥 UPDATE باستخدام ApiService
  Future updatePlace() async {
    setState(() => isLoading = true);

    try {
      await ApiService.put(
        "/update-place/${widget.place["id"]}",
        {
          "name": name.text,
          "address": address.text,
          "phone": phone.text,
          "whatsapp": whatsapp.text,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
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
                      "Edit Place ✏️",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                buildInput(name, "Place Name"),
                buildInput(address, "Address"),
                buildInput(phone, "Phone"),
                buildInput(whatsapp, "WhatsApp"),

                SizedBox(height: 25),

                // 🔥 Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : updatePlace,
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
        ),
      ),
    );
  }

  Widget buildInput(TextEditingController controller, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
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
  }
}