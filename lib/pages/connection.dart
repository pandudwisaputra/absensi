// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:absensi/pages/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectionPage extends StatefulWidget {
  String error;
  bool button;
  ConnectionPage({super.key, required this.error, required this.button});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(true),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/gif/no-connection.gif'),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Oops.. ${widget.error}",
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  color: Color.fromRGBO(58, 57, 57, 1.0),
                  decoration: TextDecoration.none,
                  fontSize: 12,
                ),
              ),
              const Text(
                "Mohon Periksa Jaringan Anda dan Coba Lagi",
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  decoration: TextDecoration.none,
                  color: Color.fromRGBO(58, 57, 57, 1.0),
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              widget.button == true
                  ? RawMaterialButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                          (route) => false,
                        );
                      },
                      fillColor: const Color(0xFF4285F4),
                      constraints:
                          const BoxConstraints(minHeight: 50, minWidth: 320),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      child: const Text('Muat Ulang'),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
