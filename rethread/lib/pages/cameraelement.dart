import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:rethread/pages/summarypage.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraController? controller;
  List<CameraDescription>? cameras;

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

  Future<void> _takePhoto() async {
    if (!controller!.value.isInitialized) return;
    final image = await controller!.takePicture();

    // disini harusnya masukin ke ai baru pindah ke page baru

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Summarypage(),
      ),
    );
    // print("Photo saved to: ${image.path}");
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
      // width: 300,
      child: Stack(
        children: [
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
              child: 
                Container(
                  padding: EdgeInsets.all(20),
                  child: FloatingActionButton(
                    onPressed: _takePhoto,
                    child: Icon(Icons.camera_alt),
                  ),
                ),
            ),
        ],

      )
    );
  }
}
