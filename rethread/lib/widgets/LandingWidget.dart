import 'package:flutter/material.dart';
import 'package:rethread/common/colors.dart';
import 'package:rethread/common/fonts.dart';
import 'package:rethread/pages/CameraPage.dart';

class LandingButton extends StatelessWidget {
  const LandingButton({super.key});

  @override
  Widget build(BuildContext context) {

  return Container(
            height: 240,
            width: 240,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Camerapage()),
                );
              },

              style: ElevatedButton.styleFrom(
                // alignment: Alignment.center,
                shape: const CircleBorder(),
                backgroundColor: buttonBlue,
              ),
              child: Text("Scan Image", textAlign: TextAlign.center,style: LandingButtonText,),
            ),
    );
  }
}

