import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TransportSection extends StatefulWidget {
  @override
  _TransportSectionState createState() => _TransportSectionState();
}

class _TransportSectionState extends State<TransportSection> {

  List routes = [];
  List categories = [];

  String selectedType = "توكتوك";
  int? selectedCategory;

  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController time = TextEditingController(); // ✅ جديد

  @override
  void initState() {
    super.initState();
    getRoutes();
    getCategories();
  }

  getRoutes() async {
    final data = await ApiService.get("/routes");
    setState(() => routes = data);
  }

  getCategories() async {
    final data = await ApiService.get("/categories");
    setState(() => categories = data);
  }

  // ✅ ADD
  addRoute() async {
    await ApiService.post("/add-route", {
      "type": selectedType,
      "from_location": from.text,
      "to_location": to.text,
      "price": price.text,
      "category_id": selectedCategory,
      "time": time.text, // ✅ جديد
    });

    Navigator.pop(context);
    getRoutes();
    clear();
  }

  // ✅ DELETE
  deleteRoute(id) async {
    await ApiService.delete("/delete-route/$id");
    getRoutes();
  }

  // ✅ UPDATE
  updateRoute(id) async {
    await ApiService.put("/update-route/$id", {
      "type": selectedType,
      "from_location": from.text,
      "to_location": to.text,
      "price": price.text,
      "category_id": selectedCategory,
      "time": time.text, // ✅ جديد
    });

    Navigator.pop(context);
    getRoutes();
    clear();
  }

  // ✅ CLEAR
  clear() {
    from.clear();
    to.clear();
    price.clear();
    time.clear(); // ✅ جديد
    selectedCategory = null;
    selectedType = "توكتوك";
  }

  void showForm({Map? data}) {

    if (data != null) {
      from.text = data["from_location"];
      to.text = data["to_location"];
      price.text = data["price"].toString();
      time.text = data["time"] ?? ""; // ✅ جديد
      selectedType = data["type"];
      selectedCategory = data["category_id"];
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(data == null ? "Add Route 🚗" : "Edit Route ✏️"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              DropdownButtonFormField(
                value: selectedType,
                items: ["توكتوك", "ميكروباص", "قطار"].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (v) => setState(() => selectedType = v.toString()),
                decoration: InputDecoration(labelText: "Type"),
              ),

              SizedBox(height: 10),

              DropdownButtonFormField(
                value: selectedCategory,
                hint: Text("Select Category"),
                items: categories.map((c) {
                  return DropdownMenuItem(
                    value: c["id"],
                    child: Text(c["name"]),
                  );
                }).toList(),
                onChanged: (v) => setState(() => selectedCategory = v as int),
                decoration: InputDecoration(labelText: "Category"),
              ),

              SizedBox(height: 10),

              TextField(
                controller: from,
                decoration: InputDecoration(labelText: "من (بداية المسار)"),
              ),

              TextField(
                controller: to,
                decoration: InputDecoration(labelText: "إلى (نهاية المسار)"),
              ),

              TextField(
                controller: price,
                decoration: InputDecoration(labelText: "السعر"),
              ),

              TextField(
                controller: time,
                decoration: InputDecoration(labelText: "الموعد ⏰"), // ✅ جديد
              ),

            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              data == null ? addRoute() : updateRoute(data["id"]);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transport 🚆"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showForm(),
          )
        ],
      ),

      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, i) {
          final r = routes[i];

          return Card(
            child: ListTile(
              title: Text("المسار: ${r["from_location"]} → ${r["to_location"]}"),
              subtitle: Text(
                "${r["type"]} | ${r["time"] ?? "-"} ⏰ | ${r["price"]} جنيه"
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [

                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => showForm(data: r),
                  ),

                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteRoute(r["id"]),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}