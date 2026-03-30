import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TransportViewScreen extends StatefulWidget {
  final int categoryId;

  TransportViewScreen(this.categoryId);

  @override
  _TransportViewScreenState createState() => _TransportViewScreenState();
}

class _TransportViewScreenState extends State<TransportViewScreen> {

  List routes = [];

  @override
  void initState() {
    super.initState();
    getRoutes();
  }

  getRoutes() async {
    final data = await ApiService.get("/routes-by-category/${widget.categoryId}");
    setState(() => routes = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transport 🚗")),
      body: ListView.builder(
        itemCount: routes.length,
        itemBuilder: (context, i) {
          final r = routes[i];

          return Card(
            child: ListTile(
              title: Text("${r["from_location"]} → ${r["to_location"]}"),
              subtitle: Text("${r["price"]} جنيه"),
            ),
          );
        },
      ),
    );
  }
}