import 'package:flutter/material.dart';
import 'package:f_aviation_accidents/home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
