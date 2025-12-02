import 'package:flutter/material.dart';
import 'package:rethread/common/colors.dart';
import 'package:rethread/templates/TemplateBackground.dart';
import 'package:rethread/widgets/CameraWidget.dart';

class Camerapage extends StatelessWidget {
  const Camerapage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
      ),
      
      body: Stack(
        children: [TemplateBackground01(),CameraWidget()],
      )
            

      );
  }
}