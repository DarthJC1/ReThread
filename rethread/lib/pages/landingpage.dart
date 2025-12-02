import 'package:flutter/material.dart';
import 'package:rethread/common/colors.dart';
import 'package:rethread/templates/TemplateBackground.dart';
import 'package:rethread/widgets/LandingWidget.dart';
import 'package:rethread/widgets/navbar.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundBlue,
      ),
      body: 
          Stack(
            children: [
              TemplateBackground01(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LandingButton(),
                  Navbar(),
                  ],
              )
              
            ],
          )
          
      );
  }
}