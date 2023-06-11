import 'dart:io';

import 'package:absensi/pages/face_recognition_page.dart';
import 'package:absensi/pages/jailbroken_check.dart';
import 'package:absensi/pages/add_face_recognition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark));
  await requestPermissions();
  cameras = await getAvailableCameras();
  secondCameras = await getSecondAvailableCameras();
  await firebase_core.Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.location,
    Permission.storage,
    Permission.microphone,
  ].request();

  // Periksa status perizinan
  if (statuses[Permission.location]!.isDenied ||
      statuses[Permission.camera]!.isDenied ||
      statuses[Permission.storage]!.isDenied ||
      statuses[Permission.microphone]!.isDenied) {
    exit(0);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presensi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      home: const JailBrokenCheck(),
    );
  }
}
