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

  deleteRoute(id) async {
    await ApiService.delete("/delete-route/$id");
    getRoutes();
  }

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
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          data == null ? "Add Route" : "Edit Route",
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [

              buildDropdown(
                value: selectedType,
                label: "Type",
                items: ["توكتوك", "ميكروباص", "قطار"],
                onChanged: (v) => setState(() => selectedType = v.toString()),
              ),

              SizedBox(height: 10),

              buildDropdown(
                value: selectedCategory,
                label: "Category",
                items: categories,
                isCategory: true,
                onChanged: (v) => setState(() => selectedCategory = v),
              ),

              SizedBox(height: 10),

              buildInput(from, "من (بداية المسار)"),
              buildInput(to, "إلى (نهاية المسار)"),
              buildInput(price, "السعر"),
              buildInput(time, "الموعد ⏰"), // ✅ جديد

            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              data == null ? addRoute() : updateRoute(data["id"]);
            },
            child: Text("Save"),
          )
        ],
      ),
    );
  }

  Widget buildInput(controller, label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white12,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildDropdown({
    required dynamic value,
    required String label,
    required List items,
    required Function(dynamic) onChanged,
    bool isCategory = false,
  }) {
    return DropdownButtonFormField(
      value: value,
      dropdownColor: Colors.black,
      style: TextStyle(color: Colors.white),
      items: items.map<DropdownMenuItem>((e) {
        return DropdownMenuItem(
          value: isCategory ? e["id"] : e,
          child: Text(isCategory ? e["name"] : e),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text("Transport"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showForm(),
          )
        ],
      ),

      body: Container(
        decoration: gradient(),
        child: ListView.builder(
          padding: EdgeInsets.all(15),
          itemCount: routes.length,
          itemBuilder: (context, i) {
            final r = routes[i];

            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white24),
              ),
              child: ListTile(
                title: Text(
                  "المسار: ${r["from_location"]} → ${r["to_location"]}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "${r["type"]} | ${r["time"] ?? "-"} ⏰ | ${r["price"]} جنيه",
                  style: TextStyle(color: Colors.white70),
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
      ),
    );
  }

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