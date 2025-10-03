import 'package:flutter/material.dart';
import 'package:rethread/pages/cameraelement.dart';

class Camerapage extends StatelessWidget {
  const Camerapage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Page'),
      ),
      
      // masukkan cameraelement
      body: Cameraelement(

      )
    );
  }
}