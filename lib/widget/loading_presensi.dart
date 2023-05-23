import 'package:flutter/material.dart';

pleaseWait(BuildContext context) {
            AlertDialog alert = AlertDialog(
              content: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                      margin: const EdgeInsets.only(left: 7),
                      child: const Text("Mohon Menunggu")),
                ],
              ),
            );
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(onWillPop: () async => false, child: alert);
              },
            );
          }