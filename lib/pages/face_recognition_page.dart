// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, use_build_context_synchronously

import 'package:absensi/model/check_recognition_model.dart';
import 'package:absensi/model/recognition.dart';
import 'package:absensi/ml/recognizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

Future<List<CameraDescription>> getSecondAvailableCameras() async {
  WidgetsFlutterBinding.ensureInitialized();
  return await availableCameras();
}

late List<CameraDescription> secondCameras;

class FaceRecognitionPage extends StatefulWidget {
  final CheckRecognitionModel result;
  const FaceRecognitionPage({Key? key, required this.result}) : super(key: key);

  @override
  _FaceRecognitionPageState createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage> {
  dynamic controller;
  bool isBusy = false;
  late Size size;

  late CameraDescription description = secondCameras[1];
  CameraLensDirection camDirec = CameraLensDirection.front;
  late List<Recognition> recognitions = [];

  // Mendeteksi wajah
  late FaceDetector faceDetector;

  // Mengenali wajah
  late Recognizer _recognizer;

  @override
  void initState() {
    super.initState();

    // Inisialisasi detektor wajah
    faceDetector = FaceDetector(
        options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast));

    // Inisialisasi pengenali wajah
    _recognizer = Recognizer();

    // Inisialisasi rekaman kamera
    initializeCamera();

    loadData();
  }

  void loadData() async {
    Data resultData = widget.result.data;
    Rect location = Rect.fromLTRB(
      double.parse(resultData.locationLeft),
      double.parse(resultData.locationTop),
      double.parse(resultData.locationRight),
      double.parse(resultData.locationBottom),
    );
    String cleanedInput =
        resultData.embeddings.replaceAll('[', '').replaceAll(']', '');

    List<String> stringList = cleanedInput.split(', ');
    List<double> embeddings =
        stringList.map((str) => double.parse(str)).toList();
    Recognizer.registered.putIfAbsent(
        resultData.key,
        () => Recognition(resultData.name, location, embeddings,
            double.parse(resultData.distance)));
  }

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

  // Tutup semua sumber daya
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Deteksi wajah pada sebuah frame
  dynamic _scanResults;
  CameraImage? frame;

  doFaceDetectionOnFrame() async {
    if (mounted) {
      // Mengkonversi frame ke dalam format InputImage
      InputImage inputImage = getInputImage();
      // Mengirim InputImage ke model deteksi wajah dan mendeteksi wajah-wajah
      List<Face> faces = await faceDetector.processImage(inputImage);
      if (kDebugMode) {
        print("NUMBER OF FACES =*==*==*==*==*==*=>${faces.length}");
      }
      // Melakukan pengenalan wajah pada wajah-wajah yang terdeteksi
      performFaceRecognition(faces);
      if (mounted) {
        setState(() {
          isBusy = false;
          _scanResults = recognitions;
        });
      }
    }
  }

  img.Image? image;

  // Melakukan Pengenalan Wajah
  performFaceRecognition(List<Face> faces) async {
    recognitions.clear();

    // Untuk mengonversi CameraImage menjadi Image dan memutarnya sehingga frame kita dalam mode potret
    image = _convertYUV420(frame!);
    image = img.copyRotate(
        image!, camDirec == CameraLensDirection.front ? 270 : 90);

    for (Face face in faces) {
      Rect faceRect = face.boundingBox;
      // memotong wajah dari frame
      img.Image croppedFace = img.copyCrop(
          image!,
          faceRect.left.toInt(),
          faceRect.top.toInt(),
          faceRect.width.toInt(),
          faceRect.height.toInt());

      // Meneruskan wajah yang telah dipotong ke model pengenalan wajah.
      Recognition recognition = _recognizer.recognize(croppedFace, faceRect);
      if (recognition.distance > 1) {
        recognition.name = "Unknown";
      }
      recognitions.add(recognition);
      if (recognition.name == widget.result.data.key) {
        if (mounted) {
          Navigator.maybePop(context, true);
        }
      }
    }
    if (mounted) {
      setState(() {
        isBusy = false;
        _scanResults = recognitions;
      });
    }
  }

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
    var imag = img.Image(image.width, image.height); // Membuat  buffer gambar

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // mengisi buffer gambar dengan plane[0] dari format YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0;
          planeOffset < image.height * image.width;
          planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // menghitung warna piksel
        var newVal =
            shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        imag.data[planeOffset + x] = newVal;
      }
    }

    return imag;
  }

  int yuv2rgb(int y, int u, int v) {
    // mengonversi piksel YUV menjadi RGB
    var r = (y + v * 1436 / 1024 - 179).round();
    var g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
    var b = (y + u * 1814 / 1024 - 227).round();

    // membatasi nilai-nilai RGB agar berada di dalam rentang [0, 255]
    r = r.clamp(0, 255);
    g = g.clamp(0, 255);
    b = b.clamp(0, 255);

    return 0xff000000 |
        ((b << 16) & 0xff0000) |
        ((g << 8) & 0xff00) |
        (r & 0xff);
  }

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

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(frame!.format.raw);

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

  // menampilkan persegi panjang (rectangle) di sekitar wajah-wajah yang terdeteksi
  Widget buildResult() {
    if (_scanResults == null ||
        controller == null ||
        !controller.value.isInitialized) {
      return const Center(child: Text('Camera is not initialized'));
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stackChildren = [];
    size = MediaQuery.of(context).size;
    if (controller != null) {
      // menampilkan rekaman kamera secara live
      stackChildren.add(
        Positioned(
          top: 0.0,
          left: 0.0,
          width: size.width,
          height: size.height,
          child: Container(
            child: (controller.value.isInitialized)
                ? FittedBox(
                    fit: BoxFit
                        .cover, // Menyesuaikan tampilan kamera dengan fit.cover
                    child: SizedBox(
                      width: controller.value.previewSize!.height,
                      height: controller.value.previewSize!.width,
                      child: CameraPreview(controller),
                    ),
                  )
                : Container(),
          ),
        ),
      );

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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
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
