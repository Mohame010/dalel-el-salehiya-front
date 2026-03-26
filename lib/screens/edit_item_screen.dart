import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EditItemScreen extends StatefulWidget {
  final Map item;

  EditItemScreen({required this.item});

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    name.text = widget.item["name"];
    price.text = widget.item["price"];
  }

  // 🔥 UPDATE باستخدام ApiService
  Future updateItem() async {
    setState(() => isLoading = true);

    try {
      await ApiService.put(
        "/update-item/${widget.item["id"]}",
        {
          "name": name.text,
          "price": price.text,
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
        title: Text("Edit Item"),
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

            // 🔥 Name
            TextField(
              controller: name,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Item Name",
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

            // 🔥 Price
            TextField(
              controller: price,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Price",
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
                onPressed: isLoading ? null : updateItem,
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