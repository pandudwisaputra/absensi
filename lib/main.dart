import 'package:absensi/pages/jailbroken_check.dart';
import 'package:absensi/pages/add_face_recognition_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white,
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark));
  cameras = await getAvailableCameras();
  await firebase_core.Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
  SharedPreferences server = await SharedPreferences.getInstance();
  await server.setString('server', 'http://api.myfin.id:4000/api');
  // await server.setString('server', 'http://103.174.114.128:4000/api');
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
