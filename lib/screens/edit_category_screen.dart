import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditCategoryScreen extends StatefulWidget {
  final Map category;

  EditCategoryScreen({required this.category});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {

  late TextEditingController nameController;
  late TextEditingController imageController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category["name"]);
    imageController = TextEditingController(text: widget.category["image"]);
  }

  // 🔥 UPDATE باستخدام ApiService
  Future updateCategory() async {
    setState(() => isLoading = true);

    try {
      await ApiService.put(
        "/update-category/${widget.category["id"]}",
        {
          "name": nameController.text,
          "image": imageController.text,
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Edit Category ✏️",
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

                        // 🔥 Name
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
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // 🔥 Image
                        TextField(
                          controller: imageController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Image URL",
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

                        SizedBox(height: 30),

                        // 🔥 Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: isLoading ? null : updateCategory,
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
            ],
          ),
        ),
      ),
    );
  }
}
