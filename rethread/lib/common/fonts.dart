import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const LandingButtonText = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  fontFamily: 'Livvic',
  color: Colors.black // optional if you use a custom font
);

const PrevPageText = TextStyle(
  fontSize: 20,
  fontFamily: 'Geist',
  color: Colors.white // optional if you use a custom font
);

TextStyle SummaryText(double fontsize) {
  return TextStyle(
    fontSize: fontsize,
    fontFamily: 'Livvic',
    color: Colors.white,
  );
}