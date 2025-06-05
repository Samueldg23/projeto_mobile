import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const TrabalhosApp());
}

class TrabalhosApp extends StatelessWidget {
  const TrabalhosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trabalhos Acadêmicos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: LoginScreen()
    );
  }
}
