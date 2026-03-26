import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_place_screen.dart';

class PlacesAdminScreen extends StatefulWidget {
  @override
  State<PlacesAdminScreen> createState() => _PlacesAdminScreenState();
}

class _PlacesAdminScreenState extends State<PlacesAdminScreen> {

  List places = [];
  List filtered = [];
  Map stats = {};

  bool isLoading = true;

  TextEditingController search = TextEditingController();

  Future fetchPlaces() async {
    final data = await ApiService.get("/all-places");

    setState(() {
      places = data;
      filtered = data;
      isLoading = false;
    });
  }

  Future fetchStats() async {
    final data = await ApiService.get("/stats");

    setState(() {
      stats = data;
    });
  }

  void searchPlaces(String value) {
    setState(() {
      filtered = places
          .where((p) =>
              p["name"].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Future deletePlace(int id) async {
    await ApiService.delete("/delete-place/$id");
    fetchPlaces();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted 🔥")),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchPlaces();
    fetchStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: Column(
            children: [

              // 🔥 Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Dashboard 📊",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // 🔥 Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  statCard("Categories", stats["categories"]),
                  statCard("Places", stats["places"]),
                  statCard("Items", stats["items"]),
                ],
              ),

              SizedBox(height: 15),

              // 🔍 Search
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: search,
                  onChanged: searchPlaces,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search places...",
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(Icons.search, color: Colors.white),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // 🔥 List
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filtered.isEmpty
                        ? Center(
                            child: Text(
                              "No Places 😢",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final place = filtered[index];

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

                                    leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        place["image"],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    title: Text(
                                      place["name"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),

                                    subtitle: Text(
                                      place["address"],
                                      style:
                                          TextStyle(color: Colors.white70),
                                    ),

                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    EditPlaceScreen(
                                                        place: place),
                                              ),
                                            ).then((_) => fetchPlaces());
                                          },
                                        ),

                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            deletePlace(place["id"]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statCard(String title, dynamic value) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Text(
            value?.toString() ?? "0",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Text(title, style: TextStyle(color: Colors.white70)),
        ],
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
