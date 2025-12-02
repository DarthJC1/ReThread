import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rethread/common/colors.dart';
import 'package:rethread/common/fonts.dart';
import 'package:rethread/pages/CameraPage.dart';

class SummaryDescWidget extends StatelessWidget {
  final int prediction;
  final String imagePath;
  final String classification;
  final String aiDescription;

  const SummaryDescWidget({
    super.key,
    required this.prediction, 
    required this.imagePath,
    required this.classification,
    required this.aiDescription,
  });

  @override
  Widget build(BuildContext context) {

  return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the captured image
            if (imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(imagePath),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            
            // Classification
            Text(
              'Classification: $classification',
              style: SummaryText(20)
            ),
            const SizedBox(height: 8),
            
            // AI Description
            Text(
              'AI Description:',
              style: SummaryText(18),
            ),
            const SizedBox(height: 8),
            Text(
              aiDescription,
              style: SummaryText(16),
            ),
          ],
        ),
    );
  }
}

