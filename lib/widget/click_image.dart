import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

clickImage(BuildContext context, String image) {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black54,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 140,
            backgroundImage: NetworkImage(image),
          )
        ],
      ),
    ),
  ).then((value) => SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark)));
}
