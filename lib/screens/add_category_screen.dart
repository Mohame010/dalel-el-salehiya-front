
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../services/api_service.dart'; // ✅ استخدم ApiService

class AddCategoryScreen extends StatefulWidget {
  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {

  TextEditingController nameController = TextEditingController();

  Uint8List? imageBytes;
  String? imageUrl;

  // 🔥 اختيار صورة (Web)
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

  // 🔥 رفع الصورة باستخدام ApiService
  Future uploadImage() async {
    imageUrl = await ApiService.uploadImage(imageBytes!);
  }

  // 🔥 إضافة الكاتيجوري باستخدام ApiService
  Future addCategory() async {

    if (imageBytes == null) {
      print("No image selected ❌");
      return;
    }

    // رفع الصورة الأول
    await uploadImage();

    print("Uploaded URL: $imageUrl");

    if (imageUrl == null) {
      print("Upload failed ❌");
      return;
    }

    await ApiService.post(
      "add-category",
      {
        "name": nameController.text,
        "image": imageUrl,
      },
    );

    Navigator.pop(context);
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              // 🔥 عنوان
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Add Category ✨",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [

                        // 🔥 الاسم
                        TextField(
                          controller: nameController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Category Name",
                            labelStyle: TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white24),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // 🔥 عرض الصورة
                        imageBytes != null
                            ? Image.memory(imageBytes!, height: 120)
                            : Text(
                                "No Image Selected",
                                style: TextStyle(color: Colors.white70),
                              ),

                        SizedBox(height: 10),

                        // 🔥 زرار اختيار صورة
                        ElevatedButton(
                          onPressed: pickImage,
                          child: Text("Pick Image"),
                        ),

                        SizedBox(height: 30),

                        // 🔥 زرار الإضافة
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: addCategory,
                            child: Text(
                              "Add",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}