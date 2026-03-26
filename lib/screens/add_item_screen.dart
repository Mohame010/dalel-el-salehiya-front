import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/api_service.dart'; // ✅ الجديد

class AddItemScreen extends StatefulWidget {
  final int? placeId;

  AddItemScreen({this.placeId});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  Uint8List? imageBytes;
  String? imageUrl;

  List places = [];
  String? selectedPlaceId;

  bool isLoading = false;

  // 🔥 Fetch Places باستخدام ApiService
  Future fetchPlaces() async {
    final data = await ApiService.get("/all-places");

    setState(() {
      places = data;

      if (widget.placeId != null) {
        selectedPlaceId = widget.placeId.toString();
      }
    });
  }

  // 📸 Pick Image
  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final bytes = await picked.readAsBytes();

      print("IMAGE PICKED LENGTH: ${bytes.length}");

      setState(() {
        imageBytes = bytes;
      });
    } else {
      print("NO IMAGE SELECTED ❌");
    }
  }

  // 🔥 Upload Image باستخدام ApiService
  Future uploadImage() async {

    if (imageBytes == null) {
      print("IMAGE BYTES NULL ❌");
      return;
    }

    print("START UPLOAD...");

    imageUrl = await ApiService.uploadImage(imageBytes!);

    print("FINAL IMAGE URL: $imageUrl");
  }

  // 🔥 Add Item باستخدام ApiService
  Future addItem() async {

    if (name.text.isEmpty ||
        price.text.isEmpty ||
        imageBytes == null ||
        selectedPlaceId == null) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fill all fields ❌")),
      );
      return;
    }

    setState(() => isLoading = true);

    print("NAME: ${name.text}");
    print("PRICE: ${price.text}");
    print("PLACE: $selectedPlaceId");

    await uploadImage();

    print("IMAGE AFTER UPLOAD: $imageUrl");

    try {
      await ApiService.post(
        "/add-item",
        {
          "name": name.text,
          "price": price.text,
          "image": imageUrl,
          "place_id": selectedPlaceId,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Added Successfully 🔥")),
      );

      Navigator.pop(context);

    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error 💀")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchPlaces();
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
                      "Add Item 🍔",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white12,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: imageBytes != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.memory(imageBytes!, fit: BoxFit.cover),
                          )
                        : Center(
                            child: Text(
                              "Tap to pick image 📸",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                  ),
                ),

                SizedBox(height: 20),

                buildInput(name, "Item Name"),
                buildInput(price, "Price"),

                SizedBox(height: 10),

                DropdownButtonFormField(
                  value: selectedPlaceId,
                  dropdownColor: Colors.black,
                  decoration: input("Select Place"),
                  items: places.map((p) {
                    return DropdownMenuItem(
                      value: p["id"].toString(),
                      child: Text(p["name"]),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedPlaceId = val.toString();
                  },
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : addItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: isLoading
                        ? CircularProgressIndicator(color: Colors.black)
                        : Text("Add Item"),
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
        decoration: input(label),
      ),
    );
  }

  InputDecoration input(String label) {
    return InputDecoration(
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
    );
  }
}