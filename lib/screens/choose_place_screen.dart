import 'package:flutter/material.dart';
import '../services/api_service.dart';

import 'add_item_screen.dart';
import 'items_by_place_screen.dart';

class ChoosePlaceScreen extends StatefulWidget {
  @override
  State<ChoosePlaceScreen> createState() => _ChoosePlaceScreenState();
}

class _ChoosePlaceScreenState extends State<ChoosePlaceScreen> {

  List places = [];
  bool isLoading = true;

  // 🔥 GET باستخدام ApiService
  Future fetchPlaces() async {
    setState(() => isLoading = true);

    final data = await ApiService.get("/all-places");

    setState(() {
      places = data;
      isLoading = false;
    });
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
          child: Column(
            children: [

              // 🔥 Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Choose Place 🏪",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : places.isEmpty
                        ? Center(
                            child: Text("No Places 😢",
                                style: TextStyle(color: Colors.white70)),
                          )
                        : ListView.builder(
                            itemCount: places.length,
                            itemBuilder: (context, index) {
                              final place = places[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (_) {
                                        return Container(
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            color: Colors.black87,
                                            borderRadius:
                                                BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              Text(
                                                place["name"],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              SizedBox(height: 15),

                                              // 👀 View Items
                                              ListTile(
                                                leading: Icon(Icons.visibility,
                                                    color: Colors.white),
                                                title: Text("View Items",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                onTap: () {
                                                  Navigator.pop(context);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          ItemsByPlaceScreen(
                                                        placeId: place["id"],
                                                        placeName:
                                                            place["name"],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),

                                              // ➕ Add Item
                                              ListTile(
                                                leading: Icon(Icons.add,
                                                    color: Colors.white),
                                                title: Text("Add Item",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                onTap: () {
                                                  Navigator.pop(context);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          AddItemScreen(
                                                        placeId: place["id"],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(18),
                                      color: Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                          color: Colors.white24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          EdgeInsets.all(12),

                                      leading: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        child: Image.network(
                                          place["image"],
                                          width: 55,
                                          height: 55,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      title: Text(
                                        place["name"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      subtitle: Text(
                                        place["address"],
                                        style: TextStyle(
                                            color: Colors.white70),
                                      ),

                                      trailing: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white70,
                                        size: 16,
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
