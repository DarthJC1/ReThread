import 'package:flutter/material.dart';
import 'package:rethread/templates/TemplateBackground.dart';
import 'package:rethread/widgets/navbar.dart';

class Testingpage extends StatelessWidget {
  Testingpage({super.key});

  String? selectedValue;
  final List<String> items = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: 
        Stack(children: [
          TemplateBackground01(),
          Navbar(),
        ],
      )
    );
  }
}