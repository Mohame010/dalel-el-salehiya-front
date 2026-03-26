import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/api_service.dart';

class AddAdScreen extends StatefulWidget {
  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {

  TextEditingController linkController = TextEditingController();

  Uint8List? imageBytes;
  String? imageUrl;

  bool isLoading = false;

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

  Future uploadImage() async {
    imageUrl = await ApiService.uploadImage(imageBytes!);
  }

  Future addAd() async {
    if (imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pick image first ❌")),
      );
      return;
    }

    setState(() => isLoading = true);

    await uploadImage();

    await ApiService.post(
      "/add-ad",
      {
        "image": imageUrl,
        "link": linkController.text,
      },
    );

    setState(() => isLoading = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Ad"),
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

            // 🔥 Image Picker Card
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white12,
                  border: Border.all(color: Colors.white24),
                ),
                child: imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          imageBytes!,
                          fit: BoxFit.cover,
                        ),
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

            // 🔥 Link Input
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
                onPressed: isLoading ? null : addAd,
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
                        "Add Ad",
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
