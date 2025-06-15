import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CardapioApp());
}

class CardapioApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardápio Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: HomeScreen(),
    );
  }
}
