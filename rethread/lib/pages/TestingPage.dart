import 'package:flutter/material.dart';
import 'package:rethread/templates/TemplateBackground.dart';
import 'package:rethread/widgets/navbar.dart';

class Testingpage extends StatelessWidget {
  const Testingpage({super.key});

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