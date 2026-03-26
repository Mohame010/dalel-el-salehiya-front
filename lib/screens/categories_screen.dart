import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_category_screen.dart';
import '../widgets/app_header.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {

  List categories = [];
  bool isLoading = true;

  // 🔥 GET
  Future fetchCategories() async {
    setState(() => isLoading = true);

    final data = await ApiService.get("/categories");

    setState(() {
      categories = data;
      isLoading = false;
    });
  }

  // 🔥 DELETE
  Future deleteCategory(int id) async {
    await ApiService.delete("/delete-category/$id");

    fetchCategories();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted 🔥")),
    );
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text("Delete Category"),
        content: Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              deleteCategory(id);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
              AppHeader(title: "Categories 🔥"),

              Padding(
                padding: EdgeInsets.all(20),
                  ),
                
              

              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : categories.isEmpty
                        ? Center(
                            child: Text(
                              "No Categories 😢",
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final item = categories[index];

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditCategoryScreen(category: item),
                                      ),
                                    ).then((_) {
                                      fetchCategories();
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
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
                                      contentPadding: EdgeInsets.all(15),

                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: item["image"] != null
                                            ? Image.network(
                                                item["image"],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )
                                            : Icon(Icons.image, color: Colors.white),
                                      ),

                                      title: Text(
                                        item["name"],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      trailing: IconButton(
                                        icon: Icon(Icons.delete, color: Colors.redAccent),
                                        onPressed: () {
                                          confirmDelete(item["id"]);
                                        },
                                      ),
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
}