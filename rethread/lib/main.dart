import 'package:flutter/material.dart';
import 'package:rethread/pages/CameraPage.dart';
import 'package:rethread/pages/LLM_test.dart';
import 'package:rethread/pages/LandingPage.dart';
import 'package:rethread/pages/TestingPage.dart';
import 'package:rethread/templates/TemplateBackground.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),

    );

  }
}
