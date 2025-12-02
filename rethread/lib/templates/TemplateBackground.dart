import 'package:flutter/material.dart';
import 'package:rethread/common/colors.dart';

void main() {
  runApp(const TemplateBackground01());
}

class TemplateBackground01 extends StatelessWidget {
  const TemplateBackground01({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(color: backgroundBlue,)
    );

  }
}
