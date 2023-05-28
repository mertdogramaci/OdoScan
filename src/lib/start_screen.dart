import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_crop/image_crop.dart';
import 'package:flutter_native_image/flutter_native_image.dart';


// import 'package:image_cropper/image_cropper.dart';
// import 'package:image/image.dart' as img;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_image/flutter_image.dart';


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
                label: const Text('Live Detection'),
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
                label: const Text('Detection on Image'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate to the YoloVideo widget for live camera detection
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ServerCamera(), // Replace with YoloVideo widget
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 1, 95),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_forward_ios),
                label: const Text('Open Camera'),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Navigate to the YoloVideo widget for live camera detection
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetHistory(), // Replace with YoloVideo widget
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 33, 1, 95),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.arrow_forward_ios),
                label: const Text('Vehicle History'),
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
    controller = CameraController(cameras[0], ResolutionPreset.high);
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
    final double previewSquareSize = size.width < size.height ? size.width : size.height;
    final double xOffset = (size.width - previewSquareSize) / 2;
    final double yOffset = (size.height - previewSquareSize) / 2;

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Waiting for the model to be loaded"),
        ),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          left: xOffset,
          top: yOffset,
          width: previewSquareSize,
          height: previewSquareSize,
          child: AspectRatio(
            aspectRatio: 1.0, // Set aspect ratio to 1 for a square shape
            child: CameraPreview(
              controller,
            ),
          ),
        ),
        ...displayBoxesAroundRecognizedObjects(size, xOffset, yOffset, previewSquareSize),
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

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen, double xOffset, double yOffset, double previewSquareSize) {
    if (yoloResults.isEmpty) return [];
    double factorX = previewSquareSize / (cameraImage?.height ?? 1);
    double factorY = previewSquareSize / (cameraImage?.width ?? 1);

    Color colorPick = Color.fromARGB(255, 55, 20, 255);

    return yoloResults.map((result) {
      return Positioned(
        left: xOffset + result["box"][0] * factorX,
        top: yOffset + result["box"][1] * factorY,
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
              fontSize: 6,
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
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    vision = FlutterVision();
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // await vision.closeYoloModel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Waiting for the model to be loaded"),
        ),
      );
    }
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
      isLoaded = true;
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
              fontSize: 6,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class ServerCamera extends StatefulWidget {
  ServerCamera({Key? key}) : super(key: key);

  @override
  State<ServerCamera> createState() => _ServerCameraState();
}

class _ServerCameraState extends State<ServerCamera> {
  late CameraController controller;
  late FlutterVision vision;
  bool isLoaded = false;
  XFile? pictureFile;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
  }

  init() async {
    List<CameraDescription> cameras = await availableCameras();
    vision = FlutterVision();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double previewSquareSize = size.width < size.height ? size.width : size.height;
    final double xOffset = (size.width - previewSquareSize) / 2;
    final double yOffset = (size.height - previewSquareSize) / 2;

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Waiting for the camera to be loaded"),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (pictureFile == null)
            Positioned(
              left: xOffset,
              top: yOffset,
              width: previewSquareSize,
              height: previewSquareSize,
              child: cameraView(),
            ),
          if (pictureFile != null)
            Positioned(
              left: 0,
              top: 0,
              width: size.width,
              height: size.height,
              child: Image.file(
                File(pictureFile!.path),
                fit: BoxFit.cover,
              ),
            ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (pictureFile == null)
                  ElevatedButton(
                    onPressed: _takePicture,
                    child: Text('Take Picture'),
                  ),
                if (pictureFile != null)
                  ElevatedButton(
                    onPressed: _retakePicture,
                    child: Text('Retake Picture'),
                  ),
                if (pictureFile != null)
                  ElevatedButton(
                    onPressed: _sendToServer,
                    child: Text('Send to Server'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cameraView() {
    return AspectRatio(
      aspectRatio: 1.0, // Set aspect ratio to 1 for a square shape
      child: CameraPreview(controller),
    );
  }

  void _takePicture() async {
    try {
      // Ensure that the camera is initialized.
      if (!controller.value.isInitialized) {
        return;
      }

      // Capture a picture as an XFile.
      pictureFile = await controller.takePicture();

      // Crop the captured picture
      pictureFile = await _cropPicture(pictureFile!, 1.0);

      setState(() {
        // Update the UI to display the captured picture.
        pictureFile = pictureFile;
      });
    } catch (e) {
      print('Error occurred while taking picture: $e');
    }
  }

  void _retakePicture() {
    setState(() {
      // Clear the captured picture.
      pictureFile = null;
    });
  }

  void _sendToServer() async {
    try {
      // Ensure that the picture file exists.
      if (pictureFile == null) {
        return;
      }

      String? deviceId = await _getId();

      // Send the image file to your server using an HTTP request or any other method you prefer.
      // Example: http.post('your_server_url', body: File(pictureFile!.path).readAsBytes());
      // Replace 'your_server_url' with the actual URL of your server endpoint.

      // You can perform any additional operations as needed after sending the image to the server.
    } catch (e) {
      print('Error occurred while sending picture to server: $e');
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  Future<XFile> _cropPicture(XFile file, double shortSideSize) async {
    // Read the image file properties
    final properties = await FlutterNativeImage.getImageProperties(file.path);

    // Calculate the size for resizing the image
    final int size = properties.width < properties.height ? properties.width : properties.height;

    // Resize the image
    final resizedImage = await FlutterNativeImage.resizeImage(file.path, width: size, height: size);

    // Calculate the coordinates for cropping a square image
    final int offsetX = (resizedImage.width - size) ~/ 2;
    final int offsetY = (resizedImage.height - size) ~/ 2;

    // Crop the image
    final croppedImage = await FlutterNativeImage.cropImage(resizedImage, offsetX, offsetY, size, size);

    // Save the cropped image to a file
    final croppedFile = await FlutterNativeImage.writeImageToPath(croppedImage, file.path);

    return XFile(croppedFile);
  }


}

class GetHistory extends StatefulWidget {
  @override
  _GetHistoryState createState() => _GetHistoryState();
}

class _GetHistoryState extends State<GetHistory> {
  List<Map<String, dynamic>> historyList = []; // List to store {date, odometer} pairs

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data from the server when the widget is initialized
  }

  Future<void> fetchData() async {
    // TODO: Send request to the server to get the list of {date, odometer} pairs
    // Replace the API call with your actual implementation
    // Make sure to handle errors and update the state accordingly
    try {
      // Simulating API call with a delay of 2 seconds
      await Future.delayed(Duration(seconds: 2));

      String? deviceId = await _getId();
      // Sample response data
      List<Map<String, dynamic>> responseData = [
        {"date": deviceId, "odometer": 50000},
        {"date": "2023-05-26", "odometer": 49500},
        {"date": "2023-05-25", "odometer": 49000},
        {"date": "2023-05-27", "odometer": 50000},
        {"date": "2023-05-26", "odometer": 49500},
        {"date": "2023-05-25", "odometer": 49000},
        {"date": "2023-05-27", "odometer": 50000},
        {"date": "2023-05-26", "odometer": 49500},
        {"date": "2023-05-25", "odometer": 49000},
        {"date": "2023-05-27", "odometer": 50000},
        {"date": "2023-05-26", "odometer": 49500},
        {"date": "2023-05-25", "odometer": 49000},
        {"date": "2023-05-27", "odometer": 50000},
        {"date": "2023-05-26", "odometer": 49500},
        {"date": "2023-05-25", "odometer": 49000},
        {"date": "2023-05-27", "odometer": 50000},
        {"date": "2023-05-26", "odometer": 49500},
        {"date": "2023-05-25", "odometer": 49000},
      ];

      setState(() {
        historyList = responseData; // Update the state with the fetched data
      });
    } catch (e) {
      // Handle error
      print('Error fetching history: $e');
    }
  }

  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle History'),
      ),
      body: ListView.builder(
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final historyItem = historyList[index];
          final date = historyItem['date'];
          final odometer = historyItem['odometer'];

          return ListTile(
            title: Text('Date: $date'),
            subtitle: Text('Odometer: $odometer'),
          );
        },
      ),
    );
  }
}



// class VehicleInfo {
//   final String date;
//   final double odometer;

//   VehicleInfo({required this.date, required this.odometer});
// }


// class NetworkService {
//   Future<List<VehicleInfo>> fetchVehicleHistory() async {
//     final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

//     if (response.statusCode == 200) {
//       final jsonList = json.decode(response.body) as List<dynamic>;
//       return jsonList
//           .map((json) => VehicleInfo(
//                 date: json['date'],
//                 odometer: json['odometer'].toDouble(),
//               ))
//           .toList();
//     } else {
//       throw Exception('Failed to fetch vehicle history');
//     }
//   }
// }




// class ServerCamera extends StatefulWidget {
// ServerCamera({Key? key}) : super(key: key);

//   @override
//   State<ServerCamera> createState() => _ServerCameraState();
// }

// class _ServerCameraState extends State<ServerCamera> {
//   late CameraController controller;
//   late FlutterVision vision;
//   CameraImage? cameraImage;
//   bool isLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     init();
//   }

//   @override
//   void dispose() async {
//     super.dispose();
//     controller.dispose();
//   }

//   init() async {
//     cameras = await availableCameras();
//     vision = FlutterVision();
//     controller = CameraController(cameras[0], ResolutionPreset.high);
//     await controller.initialize();
//     setState(() {
//       isLoaded = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     final double previewSquareSize = size.width < size.height ? size.width : size.height;
//     final double xOffset = (size.width - previewSquareSize) / 2;
//     final double yOffset = (size.height - previewSquareSize) / 2;

//     if (!isLoaded) {
//       return const Scaffold(
//         body: Center(
//           child: Text("Waiting for the camera to be loaded"),
//         ),
//       );
//     }

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         Positioned(
//           left: xOffset,
//           top: yOffset,
//           width: previewSquareSize,
//           height: previewSquareSize,
//           child: AspectRatio(
//             aspectRatio: 1.0, // Set aspect ratio to 1 for a square shape
//             child: CameraPreview(
//               controller,
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: 16.0,
//           left: 16.0,
//           right: 16.0,
//           child: ElevatedButton(
//             onPressed: _takePictureAndSendToServer,
//             child: Text('Take Picture'),
//           ),
//         ),
//       ],
//     );
//   }

//   void _takePictureAndSendToServer() async {
//     try {
//       // Ensure that the camera is initialized.
//       if (!controller.value.isInitialized) {
//         return;
//       }
      
//       // Capture a picture and convert it to a Uint8List.
//       final XFile pictureFile = await controller.takePicture();
//       final bytes = await pictureFile.readAsBytes();

//       // Send the image bytes to your server using an HTTP request or any other method you prefer.
//       // Example: http.post('your_server_url', body: bytes);
//       // Replace 'your_server_url' with the actual URL of your server endpoint.

//       // You can also display the captured image or perform any other operations as needed.
//     } catch (e) {
//       print('Error occurred while taking picture: $e');
//     }
//   }
// }

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



  // @override
  // Widget build(BuildContext context) {
  //   final Size size = MediaQuery.of(context).size;
  //   // if (!isLoaded) {
  //   //   return const Scaffold(
  //   //     body: Center(
  //   //       child: Text("Model not loaded, waiting for it"),
  //   //     ),
  //   //   );
  //   // }
  //   return Stack(
  //     fit: StackFit.expand,
  //     children: [
  //       AspectRatio(
  //         aspectRatio: controller.value.aspectRatio,
  //         child: CameraPreview(
  //           controller,
  //         ),
  //       ),
  //       ...displayBoxesAroundRecognizedObjects(size),
  //     ],
  //   );
  // }





  // List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
  //   if (yoloResults.isEmpty) return [];
  //   double factorX = screen.width / (cameraImage?.height ?? 1);
  //   double factorY = screen.height / (cameraImage?.width ?? 1);

  //   Color colorPick = Color.fromARGB(255, 55, 20, 255);

  //   return yoloResults.map((result) {
  //     return Positioned(
  //       left: result["box"][0] * factorX,
  //       top: result["box"][1] * factorY,
  //       width: (result["box"][2] - result["box"][0]) * factorX,
  //       height: (result["box"][3] - result["box"][1]) * factorY,
  //       child: Container(
  //         decoration: BoxDecoration(
  //           borderRadius: const BorderRadius.all(Radius.circular(4.0)),
  //           border: Border.all(color: Color.fromARGB(255, 255, 0, 0), width: 2.0),
  //         ),
  //         child: Text(
  //           "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
  //           style: TextStyle(
  //             background: Paint()..color = colorPick,
  //             color: Colors.white,
  //             fontSize: 6,
  //           ),
  //         ),
  //       ),
  //     );
  //   }).toList();
  // }