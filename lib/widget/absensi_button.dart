import 'package:flutter/material.dart';

class AbsensiButton extends StatelessWidget {
  final Function() onPressed;
  final Widget text;
  final Color? color;
  final Color? textColor;

  const AbsensiButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.color,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width),
      fillColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: TextStyle(
        color: textColor,
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: text,
      ),
    );
  }
}
