import 'package:absensi/page/jailbroken_page.dart';
import 'package:absensi/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
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
  await firebase_core.Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
  SharedPreferences server = await SharedPreferences.getInstance();
  await server.setString('server', 'http://103.174.114.128:4000/api');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _jailBroken;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool jailBroken;

    try {
      jailBroken = await FlutterJailbreakDetection.jailbroken;
    } on PlatformException {
      jailBroken = true;
    }

    if (!mounted) return;

    setState(() {
      _jailBroken = jailBroken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presensi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      home: _jailBroken == null
          ? LoginPage()
          : _jailBroken!
              ? JailBrokenPage()
              : LoginPage(),
    );
  }
}
