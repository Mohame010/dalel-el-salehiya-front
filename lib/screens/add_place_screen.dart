import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import '../services/api_service.dart';

class AddPlaceScreen extends StatefulWidget {
  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController whatsapp = TextEditingController();

  Uint8List? imageBytes;
  String? imageUrl;

  int? selectedCategory;

  List categories = [];

  // ✅ باستخدام ApiService
  Future fetchCategories() async {
    final data = await ApiService.get("/categories");

    setState(() {
      categories = data;
    });
  }

  Future pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        imageBytes = bytes;
      });
    }
  }

  // ✅ باستخدام ApiService
  Future uploadImage() async {
    imageUrl = await ApiService.uploadImage(imageBytes!);
  }

  Future addPlace() async {
    if (imageBytes == null || selectedCategory == null) return;

    await uploadImage();

    await ApiService.post(
      "/add-place",
      {
        "name": name.text,
        "image": imageUrl,
        "address": address.text,
        "phone": phone.text,
        "whatsapp": whatsapp.text,
        "category_id": selectedCategory,
      },
    );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
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

                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Add Place 🏪",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                imageBytes != null
                    ? Image.memory(imageBytes!, height: 120)
                    : Text("No Image", style: TextStyle(color: Colors.white)),

                ElevatedButton(
                  onPressed: pickImage,
                  child: Text("Pick Image"),
                ),

                SizedBox(height: 20),

                buildInput(name, "Place Name"),
                buildInput(address, "Address"),
                buildInput(phone, "Phone"),
                buildInput(whatsapp, "WhatsApp"),

                SizedBox(height: 15),

                DropdownButtonFormField(
                  dropdownColor: Colors.black,
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat["id"],
                      child: Text(cat["name"],
                          style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value as int;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: addPlace,
                    child: Text("Add Place"),
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
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
        ),
      ),
    );
  }
}
