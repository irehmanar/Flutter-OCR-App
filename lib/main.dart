import 'package:flutter/material.dart';
import 'ocr_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image to Text Convertor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OcrScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
