import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget notFound() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50),
    child: Center(
      child: Lottie.asset('assets/json/nothing.json'),
    ),
  );
}
