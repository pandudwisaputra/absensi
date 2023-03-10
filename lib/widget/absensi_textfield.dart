import 'package:flutter/material.dart';

class AbsensiTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String hintText;
  final bool obscureText;
  final String obscuringCharacter;

  AbsensiTextfield(
      {super.key,
      required this.controller,
      this.validator,
      required this.hintText,
      this.obscureText = false,
      this.obscuringCharacter = '*'});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
      showCursor: true,
      autofocus: false,
      textInputAction: TextInputAction.next,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x24000000),
              ),
              borderRadius: BorderRadius.circular(10)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0x24000000),
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue,
              ),
              borderRadius: BorderRadius.circular(10)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
              borderRadius: BorderRadius.circular(10)),
          hintText: hintText,
          hintStyle: TextStyle(fontFamily: 'Open Sans', fontSize: 14)),
    );
  }
}
