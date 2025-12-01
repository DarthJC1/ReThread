import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LlmTest extends StatefulWidget {
  const LlmTest({super.key});

  @override
  State<LlmTest> createState() => _LlmTestState();
}

class _LlmTestState extends State<LlmTest> {
  String aiDescription = 'Loading...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _testAI();
  }

  Future<void> _testAI() async {
    final description = await _getAIDescription('assets/images/images.jpg', 'shirt');
    setState(() {
      aiDescription = description;
      isLoading = false;
    });
  }

  Future<String> _getAIDescription(String imagePath, String classification) async {
    try {
      // TESTING: Read image from assets instead of camera
      final ByteData data = await rootBundle.load('assets/images/images.jpeg');
      final imageBytes = data.buffer.asUint8List();
      final base64Image = base64Encode(imageBytes);
      
      // Determine MIME type (adjust based on your test image)
      final mimeType = 'image/jpeg'; // Change to 'image/png' if using PNG
      
      // Replace with your actual Gemini API key
      const apiKey = 'AIzaSyDdHWM4jSugiEzW_fQAGYqD2ihQ4R0UNg4';
      
      // Prepare API request for Gemini
      final response = await http.post(
        // NEW, CORRECT MODEL NAME (Current Public API)
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'inline_data': {
                    'mime_type': mimeType,
                    'data': base64Image,
                  }
                },
                {
                  'text': 'This image has been classified as: $classification. '
                      'Please provide a detailed description of this clothing item, '
                      'including its visual characteristics, features, and any '
                      'notable details you observe.'
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('API Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error getting AI description: $e');
      return 'Unable to generate description at this time. Error: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('LLM Test'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/images.jpg',
                          width: 300,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'AI Description:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          aiDescription,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}