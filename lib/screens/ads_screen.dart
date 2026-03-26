import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'edit_ad_screen.dart';

class AdsScreen extends StatefulWidget {
  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {

  List ads = [];
  bool isLoading = true;

  Future fetchAds() async {
    setState(() => isLoading = true);

    final data = await ApiService.get("/ads");

    setState(() {
      ads = data;
      isLoading = false;
    });
  }

  Future deleteAd(int id) async {
    await ApiService.delete("/delete-ad/$id");

    fetchAds();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted")),
    );
  }

  void confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text("Delete Ad", style: TextStyle(color: Colors.white)),
        content: Text(
          "Are you sure?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              deleteAd(id);
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
    fetchAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        title: Text("Ads"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: gradient(),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ads.isEmpty
                ? Center(
                    child: Text(
                      "No Ads Found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(15),
                    itemCount: ads.length,
                    itemBuilder: (context, index) {
                      final ad = ads[index];

                      return Container(
                        margin: EdgeInsets.only(bottom: 15),
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
                          contentPadding: EdgeInsets.all(12),

                          // 🖼 Image
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              ad["image"],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // 📝 Text
                          title: Text(
                            ad["link"],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          subtitle: Text(
                            "Ad ID: ${ad["id"]}",
                            style: TextStyle(color: Colors.white70),
                          ),

                          // 🔥 Actions
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EditAdScreen(ad: ad),
                                    ),
                                  ).then((_) => fetchAds());
                                },
                              ),

                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  confirmDelete(ad["id"]);
                                },
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