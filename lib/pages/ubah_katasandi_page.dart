import 'dart:convert';

import 'package:absensi/pages/home/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;
import '../helper/exception_handler.dart';
import '../model/false_model.dart';
import '../widget/absensi_button.dart';
import '../widget/absensi_textfield.dart';
import 'connection.dart';

class UbahKataSandi extends StatefulWidget {
  const UbahKataSandi({super.key});

  @override
  State<UbahKataSandi> createState() => _UbahKataSandiState();
}

class _UbahKataSandiState extends State<UbahKataSandi> {
  TextEditingController passController = TextEditingController();
  TextEditingController konfirmasiController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _state = false;
  int? responseUpdatePassword;
  String? statusUpdatePassword;

  Future<void> updatePassword({required String newPassword}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('server');
      String? email = prefs.getString('email');
      int? id = prefs.getInt('idPegawai');
      final msg = jsonEncode({
        "id_user": id,
        "email": email,
        "new_password": newPassword,
      });
      var response = await http.put(Uri.parse('$baseUrl/updatepassword'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          },
          body: msg);
      print(response.body);
      if (response.statusCode == 200) {
        responseUpdatePassword = response.statusCode;
      } else {
        var decode = FalseModel.fromJson(jsonDecode(response.body));
        responseUpdatePassword = decode.code;
        statusUpdatePassword = decode.data;
      }
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      await Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Ubah Kata Sandi',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 27, right: 27),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AbsensiTextfield(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harus Diisi';
                    } else if (value.length < 8) {
                      return 'Password Minimal 8 Karakter';
                    }
                    return null;
                  },
                  controller: passController,
                  hintText: 'Masukkan Password Baru',
                  obscureText: true,
                  obscuringCharacter: '*',
                ),
                const SizedBox(
                  height: 10,
                ),
                AbsensiTextfield(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Harus Diisi';
                    } else if (value.length < 8) {
                      return 'Password Minimal 8 Karakter';
                    }
                    return null;
                  },
                  controller: konfirmasiController,
                  hintText: 'Masukkan Ulang Password Baru',
                  obscureText: true,
                  obscuringCharacter: '*',
                ),
                const SizedBox(
                  height: 30,
                ),
                AbsensiButton(
                  onPressed: () {
                    onPressUbahKataSandi(context);
                  },
                  text: setUpButtonChild(),
                  textColor: Colors.white,
                  color: Color(0xFF4285F4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == false) {
      return new Text(
        "Buat Kata Sandi",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      );
    } else {
      return SizedBox(
        height: 19,
        width: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          strokeWidth: 4.0,
        ),
      );
    }
  }

  Future<void> onPressUbahKataSandi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _state = true;
      });
      if (passController.text == konfirmasiController.text) {
        setState(() {
          _state = true;
        });
        await updatePassword(newPassword: passController.text);
        if (responseUpdatePassword == 200) {
          setState(() {
            _state = true;
          });
          showTopSnackBar(
            Overlay.of(context)!,
            const CustomSnackBar.success(
              message: 'Berhasil',
            ),
          );
          Navigator.pushReplacement(
              context, CupertinoPageRoute(builder: (context) => Navbar()));
          setState(() {
            _state = false;
          });
        } else {
          setState(() {
            _state = false;
          });
          showTopSnackBar(
            Overlay.of(context)!,
            CustomSnackBar.error(
              message: statusUpdatePassword!,
            ),
          );
        }
      } else {
        setState(() {
          _state = false;
        });
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.error(
            message: 'Password Tidak Sama',
          ),
        );
      }
    } else {
      setState(() {
        _state = false;
      });
    }
  }
}
