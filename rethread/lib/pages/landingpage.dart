import 'package:flutter/material.dart';
import 'package:rethread/pages/cameraelement.dart';
import 'package:rethread/pages/camerapage.dart';

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
              Navigator.push(context, MaterialPageRoute(builder: (context) => Camerapage()));
            },
            child: Text("Start Scanning your Clothes!", textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ),
                          ),
            style: ElevatedButton.styleFrom(
              // alignment: Alignment.center,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(100),
              backgroundColor: Colors.cyanAccent,
            ),
          ),
        ),
    );
  }
}