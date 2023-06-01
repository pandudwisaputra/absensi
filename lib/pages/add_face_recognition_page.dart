// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print

import 'package:absensi/model/recognition.dart';
import 'package:absensi/ml/recognizer.dart';
import 'package:absensi/widget/absensi_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

Future<List<CameraDescription>> getAvailableCameras() async {
  WidgetsFlutterBinding.ensureInitialized();
  return await availableCameras();
}

late List<CameraDescription> cameras;

class AddFaceRecognitionPage extends StatefulWidget {
  const AddFaceRecognitionPage({Key? key}) : super(key: key);

  @override
  _AddFaceRecognitionPageState createState() => _AddFaceRecognitionPageState();
}

class _AddFaceRecognitionPageState extends State<AddFaceRecognitionPage> {
  dynamic controller;
  bool isBusy = false;
  late Size size;

  late CameraDescription description = cameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];

  // declare face detector
  // Mendeteksi wajah
  late FaceDetector faceDetector;

  // declare face recognizer
  // Mengenali wajah
  late Recognizer _recognizer;

  @override
  void initState() {
    super.initState();

    // initialize face detector
    // Inisialisasi detektor wajah
    faceDetector = FaceDetector(
        options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast));

    // initialize face recognizer
    // Inisialisasi pengenali wajah
    _recognizer = Recognizer();

    // initialize camera footage
    // Inisialisasi rekaman kamera
    initializeCamera();
  }

  // code to initialize the camera's feed
  // kode untuk menginisialisasi feed kamera
  initializeCamera() async {
    controller = CameraController(description, ResolutionPreset.high);
    await controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.startImageStream((image) => {
            if (!isBusy)
              {isBusy = true, frame = image, doFaceDetectionOnFrame()}
          });
    });
  }

  // close all resources
  // Tutup semua sumber daya
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // face detection on a frame
  // Deteksi wajah pada sebuah frame
  dynamic _scanResults;
  CameraImage? frame;

  doFaceDetectionOnFrame() async {
    // convert frame into InputImage format
    // Mengkonversi frame ke dalam format InputImage
    InputImage inputImage = getInputImage();
    // pass InputImage to face detection model and detect faces
    // Mengirim InputImage ke model deteksi wajah dan mendeteksi wajah-wajah
    List<Face> faces = await faceDetector.processImage(inputImage);
    print("NUMBER OF FACES =*==*==*==*==*==*=>${faces.length}");
    // perform face recognition on detected faces
    // Melakukan pengenalan wajah pada wajah-wajah yang terdeteksi
    performFaceRecognition(faces);
    if (mounted) {
      setState(() {
        isBusy = false;
        _scanResults = recognitions;
      });
    }
  }

  img.Image? image;
  bool register = false;

  // perform Face Recognition
  // Melakukan Pengenalan Wajah
  performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    // convert CameraImage to Image and rotate it so that our frame will be in a portrait
    // Untuk mengonversi CameraImage menjadi Image dan memutarnya sehingga frame kita dalam mode potret
    image = _convertYUV420(frame!);
    image = img.copyRotate(
        image!, camDirec == CameraLensDirection.front ? 270 : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      // crop face
      // memotong wajah dari frame
      img.Image croppedFace = img.copyCrop(
          image!,
          faceRect.left.toInt(),
          faceRect.top.toInt(),
          faceRect.width.toInt(),
          faceRect.height.toInt());

      // pass cropped face to face recognition model
      // Meneruskan wajah yang telah dipotong ke model pengenalan wajah.
      Recognition recognition = _recognizer.recognize(croppedFace, faceRect);
      if (recognition.distance > 1) {
        recognition.name = "Unknown";
      }
      recognitions.add(recognition);

      // show face registration dialogue
      // menampilkan dialog registrasi wajah
      if (register) {
        showFaceRegistrationDialogue(croppedFace, recognition);
        register = false;
      }
    }
    if (mounted) {
      setState(() {
        isBusy = false;
        _scanResults = recognitions;
      });
    }
  }

  // Face Registration Dialogue
  // menampilkan dialog registrasi wajah 
  TextEditingController textEditingController = TextEditingController();

  showFaceRegistrationDialogue(img.Image croppedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Face Registration", textAlign: TextAlign.center),
        alignment: Alignment.center,
        content: SizedBox(
          height: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.memory(
                Uint8List.fromList(img.encodeBmp(croppedFace)),
                width: 200,
                height: 200,
              ),
              SizedBox(
                width: 200,
                child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Enter Name")),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    Recognizer.registered.putIfAbsent(
                        textEditingController.text, () => recognition);
                    textEditingController.text = "";
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Face Registered"),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(200, 40)),
                  child: const Text("Register"))
            ],
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  // method to convert CameraImage to Image
  // mengonversi CameraImage menjadi format Image
  img.Image convertYUV420ToImage(CameraImage cameraImage) {
    final width = cameraImage.width;
    final height = cameraImage.height;

    final yRowStride = cameraImage.planes[0].bytesPerRow;
    final uvRowStride = cameraImage.planes[1].bytesPerRow;
    final uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = img.Image(width, height);

    for (var w = 0; w < width; w++) {
      for (var h = 0; h < height; h++) {
        final uvIndex =
            uvPixelStride * (w / 2).floor() + uvRowStride * (h / 2).floor();
        final index = h * width + w;
        final yIndex = h * yRowStride + w;

        final y = cameraImage.planes[0].bytes[yIndex];
        final u = cameraImage.planes[1].bytes[uvIndex];
        final v = cameraImage.planes[2].bytes[uvIndex];

        image.data[index] = yuv2rgb(y, u, v);
      }
    }
    return image;
  }

  img.Image _convertYUV420(CameraImage image) {
    var imag = img.Image(image.width, image.height); // Create Image buffer Membuat | buffer gambar

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    // mengisi buffer gambar dengan plane[0] dari format YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
          planeOffset < image.height * image.width;
          planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        // menghitung warna piksel
        var newVal =
            shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        imag.data[planeOffset + x] = newVal;
      }
    }

    return imag;
  }

  int yuv2rgb(int y, int u, int v) {
    // Convert yuv pixel to rgb
    // mengonversi piksel YUV menjadi RGB
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // Clipping RGB values to be inside boundaries [ 0 , 255 ]
    // membatasi nilai-nilai RGB agar berada di dalam rentang [0, 255]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

  //  convert CameraImage to InputImage
  // mengonversi CameraImage menjadi InputImage
  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in frame!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize =
        Size(frame!.width.toDouble(), frame!.height.toDouble());
    final camera = description;
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    // if (imageRotation == null) return;

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);
    // if (inputImageFormat == null) return null;

    final planeData = frame!.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation!,
      inputImageFormat: inputImageFormat!,
      planeData: planeData,
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    return inputImage;
  }

  //  Show rectangles around detected faces
  // menampilkan persegi panjang (rectangle) di sekitar wajah-wajah yang terdeteksi
  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
    }
    final Size imageSize = Size(
      controller.value.previewSize!.height,
      controller.value.previewSize!.width,
    );
    CustomPainter painter =
        FaceDetectorPainter(imageSize, _scanResults, camDirec);
    return CustomPaint(
      painter: painter,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      // View for displaying the live camera footage
      // menampilkan rekaman kamera secara live
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  )
                : Container(),
          ),
        ),
      );

      //  View for displaying rectangles around detected aces
      // menampilkan persegi panjang (rectangle) di sekitar wajah yang terdeteksi
      stackChildren.add(
        Positioned(
            top: 0.0,
            left: 0.0,
            width: size.width,
            height: size.height,
            child: buildResult()),
      );
    }

    // View for displaying the bar to switch camera direction or for registering faces
    // menampilkan bar untuk mengganti arah kamera atau untuk mendaftarkan wajah
    stackChildren.add(
      Positioned(
        top: size.height - 140,
        left: 0,
        width: size.width,
        height: 80,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: AbsensiButton(
            onPressed: () => register = true,
            text: const Text('Submit'),
            color: Colors.white,
            textColor: const Color(0xFF4285F4),
          ),
        ),
      ),
    );

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
            margin: const EdgeInsets.only(top: 0),
            color: Colors.black,
            child: Stack(
              children: stackChildren,
            )),
      ),
    );
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.absoluteImageSize, this.faces, this.camDire2);

  final Size absoluteImageSize;
  final List<Recognition> faces;
  CameraLensDirection camDire2;

  @override
  void paint(Canvas canvas, Size size) {
    final double scaleX = size.width / absoluteImageSize.width;
    final double scaleY = size.height / absoluteImageSize.height;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.indigoAccent;

    for (Recognition face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.right) * scaleX
              : face.location.left * scaleX,
          face.location.top * scaleY,
          camDire2 == CameraLensDirection.front
              ? (absoluteImageSize.width - face.location.left) * scaleX
              : face.location.right * scaleX,
          face.location.bottom * scaleY,
        ),
        paint,
      );

      TextSpan span = TextSpan(
          style: const TextStyle(color: Colors.white, fontSize: 20),
          text: "${face.name}  ${face.distance.toStringAsFixed(2)}");
      TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas,
          Offset(face.location.left * scaleX, face.location.top * scaleY));
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return true;
  }
}
