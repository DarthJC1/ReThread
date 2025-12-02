import 'package:flutter/material.dart';
import 'dart:io';

import 'package:rethread/common/colors.dart';
import 'package:rethread/common/fonts.dart';
import 'package:rethread/templates/TemplateBackground.dart';
import 'package:rethread/widgets/SummaryDescWidget.dart';

class Summarypage extends StatelessWidget {
  final int prediction;
  final String imagePath;
  final String classification;
  final String aiDescription;

  const Summarypage({
    super.key,
    required this.prediction, 
    required this.imagePath,
    required this.classification,
    required this.aiDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Warna yang kamu inginkan
        ),
        title: Text('Summary', style: PrevPageText,),
        backgroundColor: backgroundBlue,
      ),
      body: 
        Stack(
          children: [
            TemplateBackground01(),
            SummaryDescWidget(prediction: prediction, imagePath: imagePath, classification: classification, aiDescription: aiDescription),
          ],
        )
    );
  }
}