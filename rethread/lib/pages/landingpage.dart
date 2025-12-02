import 'package:flutter/material.dart';
import 'package:rethread/widgets/CameraWidget.dart';
import 'package:rethread/pages/CameraPage.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Landing Page'),
      ),
      body: 
        Container(
          child: ElevatedButton(
            onPressed: () {
              Camerapage();
            },
            style: ElevatedButton.styleFrom(
              // alignment: Alignment.center,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(100),
              backgroundColor: Colors.cyanAccent,
            ),
            child: Text("Scan your Clothes!", textAlign: TextAlign.center,),
          ),
        ),
    );
  }
}