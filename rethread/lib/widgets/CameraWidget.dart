import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rethread/common/colors.dart';
import 'package:rethread/common/fonts.dart';
import 'package:rethread/database/Database.dart';
import 'package:rethread/pages/SummaryPage.dart';
import 'package:rethread/templates/TemplateBackground.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key});

  @override
  CamerawidgetState createState() => CamerawidgetState();
}

class CamerawidgetState extends State<CameraWidget> {
  CameraController? controller;
  String? selectedValue;
  final List<String> items = ['ShuffleNetV2', 'HOG + Color Histogram -> SVM'];
  List<CameraDescription>? cameras;
  bool isProcessing = false;

  Interpreter? _interpreter;
  List<String>? _labels;
  final int imageSize = 224;
  final List<double> mean = [0.485, 0.456, 0.406];
  final List<double> std = [0.229, 0.224, 0.225];

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadModel();
  }

  Future<void> _initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
    await controller!.initialize();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadModel() async {
    try {
      print("Loading ShuffleNet model...");
      _interpreter = await Interpreter.fromAsset(
        'assets/models/shufflenet_nchw.tflite',
      );
      print("Model loaded successfully!");

      print("Loading labels...");
      final labelsData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData.split('\n').where((e) => e.trim().isNotEmpty).toList();
      print("Labels loaded: $_labels");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<String> _getAIDescription(String imagePath, String classification) async {
    try {
      // TESTING: Read image from assets instead of camera
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      
      // Determine MIME type (adjust based on your test image)
      final mimeType = 'image/jpeg'; // Change to 'image/png' if using PNG

      await dotenv.load(fileName: "config.env");
      final apiKey = dotenv.env['GEMINI_API_KEY'];


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
                      'Please provide a detailed description of this clothing item, if there are damages in the clothing describe them, use only regular font, NO bold underline and other form of irregular use of font'
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

  Future<String?> _predictClothingFromAPI(File imageFile) async {
    try {
      // LOCAL API (emulator)
      // final uri = Uri.parse("http://10.0.2.2:8000/predict");

      // REAL DEPLOYED API
      final uri = Uri.parse("http://10.0.2.2:8000/predict");

      var request = http.MultipartRequest("POST", uri);

      request.files.add(
        await http.MultipartFile.fromPath(
          "image",
          imageFile.path,
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      print("STATUS: ${response.statusCode}");
      print("BODY: $responseBody");

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        return data["prediction"]; // e.g. "shirt", "pants", "dress"
      } else {
        print("API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error sending to API: $e");
      return null;
    }
  }

  Future<String?> _predictWithShuffleNet(String imagePath) async {
    if (_interpreter == null || _labels == null) {
      print("Model or labels not loaded");
      return null;
    }

    try {
      print("Loading image from: $imagePath");
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();

      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) throw Exception('Failed to decode image');

      print("Resizing image to ${imageSize}x$imageSize");
      image = img.copyResize(image, width: imageSize, height: imageSize);

      // Create input tensor in NCHW format: [1, 3, 224, 224]
      print("Preprocessing image (NCHW format)...");
      var input = List.generate(1, (b) =>
          List.generate(3, (c) =>
              List.generate(imageSize, (y) =>
                  List.generate(imageSize, (x) {
                    final pixel = image!.getPixel(x, y);
                    double value;
                    if (c == 0) {
                      value = pixel.r.toDouble();
                    } else if (c == 1) {
                      value = pixel.g.toDouble();
                    } else {
                      value = pixel.b.toDouble();
                    }
                    // Normalize: (pixel/255 - mean) / std
                    return (value / 255.0 - mean[c]) / std[c];
                  })
              )
          )
      );

      // Output buffer [1, 3]
      var output = List.generate(1, (_) => List<double>.filled(3, 0.0));

      print("Running inference...");
      _interpreter!.run(input, output);
      print("Inference successful!");
      print("Raw output scores: ${output[0]}");

      // Find best class
      int bestIndex = 0;
      double bestScore = output[0][0];
      for (int i = 1; i < 3; i++) {
        if (output[0][i] > bestScore) {
          bestScore = output[0][i];
          bestIndex = i;
        }
      }

      print("Prediction: ${_labels![bestIndex]}");
      return _labels![bestIndex];
    } catch (e) {
      print("ShuffleNet prediction error: $e");
      return null;
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
      final imageFile = File(image.path);
      String? classification;

      if (selectedValue == 'HOG + Color Histogram -> SVM') {
        print("Using Classical Feature Extraction");
        classification = await _predictClothingFromAPI(imageFile);
      } else if (selectedValue == 'ShuffleNetV2') {
        print("Using Deep Learning Model (ShuffleNet)");
        classification = await _predictWithShuffleNet(image.path);
      } else {
        throw Exception("Please select a model first");
      }

      if (classification == null) {
        throw Exception("Failed to classify image");
      }

      print("Classification: $classification");
      
      // TODO: Replace this with your actual classification model
      // For now using mock classifications
      final String finalClassification = classification;
      // Get AI description
      // KALAU KAMU NANYA IMAGENYA DAPET DARI MANA SETELAH DI AMBIL, PAKAI 'image.path' YAAA
      final description = await _getAIDescription(image.path, finalClassification);

      await ScanHistoryDatabase.instance.insertScan(
        imagePath: image.path,
        classification: finalClassification,
        aiDescription: description,
      );

      // Resume preview before navigation
      await controller!.resumePreview();
      
      // Navigate to summary page with prediction and description
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Summarypage(
            imagePath: image.path,
            classification: finalClassification,
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
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return 
    Column(
      
      children: [
        Container(
        height: 600,
        width: 440,
        child: Stack(
          children: [
            OverflowBox(
              child: CameraPreview(controller!), 
            ),
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
                margin: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton(
                  onPressed: isProcessing ? null : _takePhoto,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: buttonBlue,
                    fixedSize: const Size(70, 70),
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.zero, // Remove default padding
                  ),
                  child: const Center( // Wrap icon with Center
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),

      ),
      const SizedBox(height: 20),
        DropdownButton<String>(
              padding: EdgeInsets.symmetric(horizontal: 37),
              value: selectedValue,
              hint: Text('Select an option'),
              isExpanded: true,
              dropdownColor: backgroundBlue,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: SummaryText(16),),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
              },
            ),
      ],
    );  
  }
}