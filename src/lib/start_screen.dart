import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';


class StartScreen extends StatelessWidget {
  const StartScreen(this.startScanner, {Key? key}) : super(key: key);

  final void Function() startScanner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            colors: [Colors.indigo, Colors.deepPurple],
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Opacity(
                opacity: 0.8,
                child: Image.asset(
                  'assets/images/speedometer-clipart-design-illustration-free-png.webp',
                  width: 200,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'OdoScan',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 237, 223, 252),
                ),
              ),
              const SizedBox(height: 80),
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate to the YoloVideo widget for live camera detection
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YoloVideo(), // Replace with YoloVideo widget
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 1, 95),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_forward_ios),
                label: const Text('Detect on Camera'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate to the YoloImage widget for image detection
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YoloImage(), // Replace with YoloImage widget
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 1, 95),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_forward_ios),
                label: const Text('Detect on Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


late List<CameraDescription> cameras;
class YoloVideo extends StatefulWidget {
  YoloVideo({Key? key}) : super(key: key);

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
    // await vision.closeYoloModel();
  }

  init() async {
    cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    await controller.initialize();
    await loadYoloModel();
    setState(() {
      isLoaded = true;
      isDetecting = true; // Automatically start detection
      yoloResults = [];
    });
    startDetection(); // Start image stream
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // if (!isLoaded) {
    //   return const Scaffold(
    //     body: Center(
    //       child: Text("Model not loaded, waiting for it"),
    //     ),
    //   );
    // }
    return Stack(
      fit: StackFit.expand,
      children: [
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(
            controller,
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
        labels: 'assets/labels.txt',
        modelPath: 'assets/yolov8n.tflite',
        modelVersion: "yolov8",
        numThreads: 2,
        useGpu: false);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await vision.yoloOnFrame(
        bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        iouThreshold: 0.4,
        confThreshold: 0.4,
        classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) async {
      if (isDetecting) {
        cameraImage = image;
        yoloOnFrame(image);
      }
    });
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = Color.fromARGB(255, 55, 20, 255);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: Color.fromARGB(255, 255, 0, 0), width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 11.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class YoloImage extends StatefulWidget {
  YoloImage({Key? key}) : super(key: key);

  @override
  State<YoloImage> createState() => _YoloImageState();
}

class _YoloImageState extends State<YoloImage> {
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    loadYoloModel();
  }

  @override
  void dispose() {
    super.dispose();
    // await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
        imageFile != null ? Image.file(imageFile!) : const SizedBox(),
        Align(
          alignment: Alignment.bottomCenter,        
          child: ElevatedButton(
              onPressed: pickImage,
              child: const Text("Choose Odometer"),
            ),
          ),
        ...displayBoxesAroundRecognizedObjects(size),
      ],
    );
  }

  Future<void> loadYoloModel() async {
    await vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/yolov8n.tflite',
      modelVersion: "yolov8",
      numThreads: 2,
      useGpu: false,
    );
    setState(() {
      yoloResults = [];
      imageFile = null;
    });
  }

  Future<void> pickImage() async {
    final XFile? photo = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
      await yoloOnImage();
    }
  }

  Future<void> yoloOnImage() async {
    yoloResults.clear();
    final byte = await imageFile!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;
    final result = await vision.yoloOnImage(
      bytesList: byte,
      imageHeight: imageHeight,
      imageWidth: imageWidth,
      iouThreshold: 0.8,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    final factorX = screen.width / imageWidth;
    final imgRatio = imageWidth / imageHeight;
    final newWidth = imageWidth * factorX;
    final newHeight = newWidth / imgRatio;
    final factorY = newHeight / imageHeight;
    final pady = (screen.height - newHeight) / 2;

    const colorPick = Color.fromARGB(255, 55, 20, 255);
    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY + pady,
        width: (result["box"][2] - result["box"][0]) * factorX,

        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            border: Border.all(color: Color.fromARGB(255, 255, 0, 0), width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 11.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}


// Remove the CameraScreen and ImageScreen classes


// class CameraScreen extends StatelessWidget {
//   const CameraScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Camera Screen'),
//       ),
//       body: const Center(
//         child: Text('Camera Screen'),
//       ),
//     );
//   }
// }

// class ImageScreen extends StatelessWidget {
//   const ImageScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Screen'),
//       ),
//       body: const Center(
//         child: Text('Image Screen'),
//       ),
//     );
//   }
// }
