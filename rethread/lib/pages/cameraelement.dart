import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rethread/pages/summarypage.dart';

class Cameraelement extends StatefulWidget {
  const Cameraelement({super.key});

  @override
  CameraelementState createState() => CameraelementState();
}

class CameraelementState extends State<Cameraelement> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
    await controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<String> _getAIDescription(String imagePath, String classification) async {
    try {
      // TESTING: Read image from assets instead of camera
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      
      // Determine MIME type (adjust based on your test image)
      final mimeType = 'image/jpeg'; // Change to 'image/png' if using PNG
      
      // Replace with your actual Gemini API key
      const apiKey = 'AIzaSyDdHWM4jSugiEzW_fQAGYqD2ihQ4R0UNg4';
      
      // Prepare API request for Gemini
      final response = await http.post(
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
                  'text': 
                  // 'Describe what you see'
                      'This image has been classified as: $classification. '
                      'Please provide a detailed description of this clothing item, if there are damages in the clothing describe them'
                      'Estimate compensation in Rupiah they get if they turn this clothes in based on the classification and your observation and end it with please find our nearest vendor to ascertain the compensation'
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
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting AI description: $e');
      return 'Unable to generate description at this time.';
    }
  }

  Future<void> _takePhoto() async {
    if (!controller!.value.isInitialized || isProcessing) return;
    
    setState(() {
      isProcessing = true;
    });

    try {
      // Pause preview to prevent buffer issues
      await controller!.pausePreview();
      
      final image = await controller!.takePicture();
      
      // TODO: Replace this with your actual classification model
      // For now using mock classifications
      final classifications = ['shirt', 'pants', 'dress'];
      final classification = classifications[0]; // Replace with actual model prediction
      
      // Get AI description
      // KALAU KAMU NANYA IMAGENYA DAPET DARI MANA SETELAH DI AMBIL, PAKAI 'image.path' YAAA
      final description = await _getAIDescription(image.path, classification);
      
      // Resume preview before navigation
      await controller!.resumePreview();
      
      // Navigate to summary page with prediction and description
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Summarypage(
            prediction: 0, // Replace with actual prediction index
            imagePath: image.path,
            classification: classification,
            aiDescription: description,
          ),
        ),
      );
    } catch (e) {
      print('Error taking photo: $e');
      // Resume preview on error
      try {
        await controller!.resumePreview();
      } catch (_) {}
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process image')),
      );
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 720,
      child: Stack(
        children: [
          CameraPreview(controller!),
          if (isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Processing image...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              child: FloatingActionButton(
                onPressed: isProcessing ? null : _takePhoto,
                backgroundColor: isProcessing ? Colors.grey : null,
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}