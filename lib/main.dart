import 'package:flutter/material.dart';
import 'view.dart'; // Importando a view

void main() {
  runApp(CronometroApp());
}

class CronometroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CronometroPage(toggleTheme: () {}),
    );
  }
}