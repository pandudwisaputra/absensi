import 'package:absensi/pages/jailbroken_page.dart';
import 'package:absensi/pages/login_check.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

class JailBrokenCheck extends StatefulWidget {
  const JailBrokenCheck({super.key});

  @override
  State<JailBrokenCheck> createState() => _JailBrokenCheckState();
}

class _JailBrokenCheckState extends State<JailBrokenCheck> {
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
    return _jailBroken == null
        ? const LoginCheck()
        : _jailBroken!
            ? const JailBrokenPage()
            : const LoginCheck();
  }
}
