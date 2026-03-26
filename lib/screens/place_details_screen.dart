import 'package:dalel_dashboard/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final Map place;

  PlaceDetailsScreen({required this.place});

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen>
    with SingleTickerProviderStateMixin {

  List items = [];
  bool isLoading = true;
  late TabController _tabController;

  Future fetchItems() async {
    final data = await ApiService.get(
      "/items/${widget.place['id']}", // ✅ صح
    );

    setState(() {
      items = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      body: Container(
        decoration: gradient(),
        child: SafeArea(
          child: Column(
            children: [

              // 🔥 صورة + Back
              Stack(
                children: [
                  Image.network(
                    place["image"],
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),

              // 🔥 بيانات
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [

                    Text(
                      place["name"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      place["address"],
                      style: TextStyle(color: Colors.white70),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        IconButton(
                          icon: Icon(Icons.call, color: Colors.green),
                          onPressed: () {
                            launchUrl(Uri.parse("tel:${place["phone"]}"));
                          },
                        ),

                        IconButton(
                          icon: Icon(Icons.message, color: Colors.green),
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "https://wa.me/${place["whatsapp"]}"));
                          },
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              // 🔥 Tabs
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                indicatorColor: Colors.white,
                tabs: [
                  Tab(text: "Menu"),
                  Tab(text: "Info"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [

                    // 🍔 Menu
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : items.isEmpty
                            ? Center(
                                child: Text("No Items 😢",
                                    style: TextStyle(color: Colors.white70)),
                              )
                            : GridView.builder(
                                padding: EdgeInsets.all(10),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      MediaQuery.of(context).size.width > 900
                                          ? 4
                                          : 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.8,
                                ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final item = items[index];

                                  return Container(
                                    decoration: box(),
                                    child: Column(
                                      children: [

                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.vertical(
                                                  top: Radius.circular(15)),
                                          child: Image.network(
                                            item["image"],
                                            height: 90,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),

                                        SizedBox(height: 5),

                                        Text(
                                          item["name"],
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),

                                        Text(
                                          "${item["price"]} جنيه",
                                          style: TextStyle(
                                            color: Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                      ],
                                    ),
                                  );
                                },
                              ),

                    // ℹ️ Info
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        decoration: box(),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            buildInfo("📍 Address", place["address"]),
                            buildInfo("📞 Phone", place["phone"]),
                            buildInfo("💬 WhatsApp", place["whatsapp"]),

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfo(String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.white)),
          Text(value, style: TextStyle(color: Colors.white70)),
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

  BoxDecoration box() => BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white24),
      );
}
