import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'add_item_screen.dart';

class ItemsByPlaceScreen extends StatefulWidget {
  final int placeId;
  final String placeName;

  ItemsByPlaceScreen({
    required this.placeId,
    required this.placeName,
  });

  @override
  State<ItemsByPlaceScreen> createState() =>
      _ItemsByPlaceScreenState();
}

class _ItemsByPlaceScreenState extends State<ItemsByPlaceScreen> {

  List items = [];
  bool isLoading = true;

  // 🔥 GET
  Future fetchItems() async {
    setState(() => isLoading = true);

    final data = await ApiService.get("/items/${widget.placeId}");

    setState(() {
      items = data;
      isLoading = false;
    });
  }

  // 🔥 DELETE
  Future deleteItem(int id) async {
    await ApiService.delete("/delete-item/$id");

    fetchItems();
  }

  // 🔥 EDIT
  void openEdit(Map item) {
    TextEditingController name =
        TextEditingController(text: item["name"]);
    TextEditingController price =
        TextEditingController(text: item["price"].toString());

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text("Edit Item",
                  style: TextStyle(color: Colors.white, fontSize: 20)),

              SizedBox(height: 10),

              TextField(
                controller: name,
                style: TextStyle(color: Colors.white),
                decoration: input("Name"),
              ),

              SizedBox(height: 10),

              TextField(
                controller: price,
                style: TextStyle(color: Colors.white),
                decoration: input("Price"),
              ),

              SizedBox(height: 15),

              ElevatedButton(
                onPressed: () async {
                  await ApiService.put(
                    "/update-item/${item["id"]}",
                    {
                      "name": name.text,
                      "price": price.text,
                    },
                  );

                  Navigator.pop(context);
                  fetchItems();
                },
                child: Text("Save"),
              )
            ],
          ),
        );
      },
    );
  }

  InputDecoration input(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🔥 Add Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  AddItemScreen(placeId: widget.placeId),
            ),
          ).then((_) => fetchItems());
        },
        child: Icon(Icons.add),
      ),

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
                      icon: Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.placeName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? Center(
                            child: Text("No Items 💀",
                                style: TextStyle(color: Colors.white70)),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).size.width > 900
                                      ? 5
                                      : 2,
                              childAspectRatio: 0.85,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(18),
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
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    // 🖼 Image
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.vertical(
                                              top: Radius.circular(18)),
                                      child: Image.network(
                                        item["image"],
                                        height: 100,
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
                                            item["name"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          SizedBox(height: 4),

                                          Text(
                                            "${item["price"]} جنيه",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),

                                          SizedBox(height: 8),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [

                                              IconButton(
                                                icon: Icon(Icons.edit,
                                                    color: Colors.blue),
                                                onPressed: () =>
                                                    openEdit(item),
                                              ),

                                              IconButton(
                                                icon: Icon(Icons.delete,
                                                    color: Colors.red),
                                                onPressed: () =>
                                                    deleteItem(item["id"]),
                                              ),

                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
