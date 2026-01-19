import 'package:flutter/material.dart';
import 'package:project_station/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MetroApp());
}

class MetroApp extends StatelessWidget {
  const MetroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Project Station',
      home: const HomePage(), 
    );
  }
}
