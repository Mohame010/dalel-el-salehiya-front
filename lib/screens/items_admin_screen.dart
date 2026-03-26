import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ItemsAdminScreen extends StatefulWidget {
  @override
  State<ItemsAdminScreen> createState() => _ItemsAdminScreenState();
}

class _ItemsAdminScreenState extends State<ItemsAdminScreen> {

  List items = [];
  List places = [];

  String selectedPlace = "all";
  bool isLoading = true;

  // 🔥 Fetch باستخدام ApiService
  Future fetchData() async {
    setState(() => isLoading = true);

    final itemsData = await ApiService.get("/items-with-place");
    final placesData = await ApiService.get("/all-places");

    setState(() {
      items = itemsData;
      places = placesData;
      isLoading = false;
    });
  }

  List get filteredItems {
    if (selectedPlace == "all") return items;

    return items.where((item) {
      return item["place_id"].toString() == selectedPlace;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
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
          child: Column(
            children: [

              // 🔥 Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Items 🍔",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🔥 Dropdown محسّن
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: selectedPlace,
                      dropdownColor: Colors.black,
                      isExpanded: true,
                      style: TextStyle(color: Colors.white),
                      items: [
                        DropdownMenuItem(
                          value: "all",
                          child: Text("All Places"),
                        ),
                        ...places.map((p) => DropdownMenuItem(
                              value: p["id"].toString(),
                              child: Text(p["name"]),
                            )),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedPlace = val.toString();
                        });
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              "No Items 💀",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                    color: Colors.white.withOpacity(0.1),
                                    border: Border.all(color: Colors.white24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(12),

                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        item["image"],
                                        width: 55,
                                        height: 55,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    title: Text(
                                      item["name"],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    subtitle: Text(
                                      "${item["price"]} جنيه • ${item["place_name"]}",
                                      style: TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
