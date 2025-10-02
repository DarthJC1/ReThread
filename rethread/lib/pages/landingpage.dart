import 'package:flutter/material.dart';
import 'package:rethread/pages/cameraelement.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: CameraPage(

      )
    );
  }
}