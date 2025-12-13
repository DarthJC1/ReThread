import 'package:flutter/material.dart';
import 'package:rethread/common/colors.dart';
import 'package:rethread/templates/TemplateBackground.dart';
import 'package:rethread/widgets/CameraWidget.dart';
import 'package:rethread/widgets/navbar.dart';

class Camerapage extends StatelessWidget {
  const Camerapage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundBlue,
      ),
      bottomNavigationBar: Navbar(),
      body: 
            Stack(
              children: [
                TemplateBackground01(),
                CameraWidget()
                  
                ],
            ),
            
      );
      
      
  }
}