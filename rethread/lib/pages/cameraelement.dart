import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;
import 'package:rethread/pages/summarypage.dart';

class Cameraelement extends StatefulWidget {
  const Cameraelement({super.key});

  @override
  CameraelementState createState() => CameraelementState();
}

class CameraelementState extends State<Cameraelement> {
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

    // disini harusnya masukin ke ai baru pindah ke page baru, tapi sementara pakai randomizer aja dulu
    final math.Random random = math.Random();
    int ehe = random.nextInt(3);

    // ini pindah ke summary page tapi sebelum itu usahain summary page dikasi tau prediksinya apa
    Navigator.push(
      context,
      MaterialPageRoute(
        

        builder: (context) => Summarypage(prediction: ehe,),
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
