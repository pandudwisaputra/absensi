// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api, avoid_print, use_build_context_synchronously
import 'dart:convert';

import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/model/face_detector_painter.dart';
import 'package:absensi/pages/connection.dart';
import 'package:absensi/pages/home/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:absensi/model/recognition.dart';
import 'package:absensi/ml/recognizer.dart';
import 'package:absensi/widget/absensi_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
  int? responseRegister;
  dynamic controller;
  bool isBusy = false;
  late Size size;

  late CameraDescription description = cameras[1];
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
              {
                isBusy = true,
                frame = image,
                doFaceDetectionOnFrame(),
              }
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
    // Mengkonversi frame ke dalam format InputImage
    InputImage inputImage = getInputImage();
    // Mengirim InputImage ke model deteksi wajah dan mendeteksi wajah-wajah
    List<Face> faces = await faceDetector.processImage(inputImage);
    print("NUMBER OF FACES =*==*==*==*==*==*=>${faces.length}");
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

  // menampilkan dialog registrasi wajah
  showFaceRegistrationDialogue(img.Image croppedFace, Recognition recognition) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Registrasi Wajah',
                    style: TextStyle(
                      fontFamily: 'Open Sans',
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.memory(
                    Uint8List.fromList(img.encodeBmp(croppedFace)),
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // Recognizer.registered.putIfAbsent(
                        //     textEditingController.text, () => recognition);
                        onPress(context: context, recognition: recognition);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          minimumSize: const Size(200, 40)),
                      child: const Text("Konfirmasi"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  img.Image _convertYUV420(CameraImage image) {
    var imag = img.Image(image.width, image.height); // Membuat buffer gambar

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

  Future<void> registerRecognition({
    required String name,
    required Rect location,
    required List<double> embeddings,
    required double distance,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? key = prefs.getString('namaLengkap');
    int? idPegawai = prefs.getInt('idPegawai');
    try {
      var response = await http.post(
        Uri.parse('http://api.myfin.id:4000/api/recognition'),
        headers: {
          'X-API-Key': '12345678',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'id_user': idPegawai,
          'key': key,
          'name': name,
          'location_left': location.left.toString(),
          'location_top': location.top.toString(),
          'location_right': location.right.toString(),
          'location_bottom': location.bottom.toString(),
          'embeddings': embeddings.toString(),
          'distance': distance.toString(),
        }),
      );
      print(response.body);
      setState(() {
        responseRegister = response.statusCode;
      });
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
        (route) => false,
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
                ? AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
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
            text: const Text('Ambil Foto'),
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

  void onPress({
    required BuildContext context,
    required Recognition recognition,
  }) async {
    await registerRecognition(
      name: recognition.name,
      location: recognition.location,
      embeddings: recognition.embeddings,
      distance: recognition.distance,
    );
    if (responseRegister == 200) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Berhasil Menambahkan Data',
        ),
      );
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => const Navbar()),
        (route) => false,
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Gagal Menambahkan Data',
        ),
      );
    }
  }
}
