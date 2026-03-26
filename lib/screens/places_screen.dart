import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'place_details_screen.dart';

class PlacesScreen extends StatefulWidget {
  final int categoryId;

  PlacesScreen({required this.categoryId});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {

  List places = [];
  bool isLoading = true;

  Future fetchPlaces() async {
    final data =
        await ApiService.get("/places/${widget.categoryId}");

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
        decoration: gradient(),
        child: SafeArea(
          child: Column(
            children: [

              // 🔥 Header
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [

                    IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),

                    SizedBox(width: 10),

                    Text(
                      "Places 🏪",
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
                            child: Text(
                              "No Places 😢",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(15),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 900
                                      ? 4
                                      : 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: places.length,
                            itemBuilder: (context, index) {
                              final place = places[index];

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PlaceDetailsScreen(
                                              place: place),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(18),
                                    color:
                                        Colors.white.withOpacity(0.1),
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
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      // 🖼 Image
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.vertical(
                                          top: Radius.circular(18),
                                        ),
                                        child: Image.network(
                                          place["image"],
                                          height: 110,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              place["name"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),

                                            SizedBox(height: 5),

                                            Text(
                                              place["address"],
                                              style: TextStyle(
                                                color:
                                                    Colors.white70,
                                                fontSize: 12,
                                              ),
                                              maxLines: 2,
                                              overflow:
                                                  TextOverflow.ellipsis,
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
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
