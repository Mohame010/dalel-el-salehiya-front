import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final bool showBack;

  const AppHeader({
    required this.title,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [

          // 🔥 زرار الرجوع (ذكي)
          if (showBack && Navigator.canPop(context))
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),

          if (showBack && Navigator.canPop(context))
            SizedBox(width: 10),

          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
