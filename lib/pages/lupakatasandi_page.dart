import 'dart:convert';

import 'package:absensi/pages/verif_lupakatasandi_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import '../widget/absensi_button.dart';
import '../widget/absensi_textfield.dart';
import 'connection.dart';

class LupaKataSandi extends StatefulWidget {
  const LupaKataSandi({super.key});

  @override
  State<LupaKataSandi> createState() => _LupaKataSandiState();
}

class _LupaKataSandiState extends State<LupaKataSandi> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  bool? _state = false;
  int? responseEmailCheck;
  int? responseSendOtp;

  Future<void> emailCheck({required String email}) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');

      var response =
          await http.get(Uri.parse('$baseUrl/emailcheck/$email'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      print(response.body);
      responseEmailCheck = response.statusCode;
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

  Future<void> sendOtp({required String email}) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      final msg = jsonEncode(
        {
          "email": email,
        },
      );
      var response = await http.post(Uri.parse('$baseUrl/sendotp'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          },
          body: msg);
      responseSendOtp = response.statusCode;
      print(response.body);
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
            'Lupa Kata Sandi',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Atur ulang kata sandi',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Masukkan e-mail yang terdaftar. Kami akan mengirimkan kode verifikasi untuk atur ulang kata sandi anda.',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: AbsensiTextfield(
                    controller: emailcontroller,
                    hintText: 'Email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Harus Diisi';
                      } else if (!validateEmail(value)) {
                        return 'Masukkan Email Dengan Benar';
                      }
                      return null;
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              AbsensiButton(
                onPressed: () {
                  if (_state == false) {
                    onPress(context);
                  }
                },
                text: setUpButtonChild(),
                color: Color(0xFF4285F4),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  Widget setUpButtonChild() {
    if (_state == false) {
      return new Text(
        "Lanjut",
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

  void onPress(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _state = true;
      });
      await emailCheck(email: emailcontroller.text);
      if (responseEmailCheck == 404) {
        setState(() {
          _state = true;
        });
        await sendOtp(email: emailcontroller.text);
        if (responseSendOtp == 200) {
          setState(() {
            _state = true;
          });
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: ((context) => VerifLupaPw(
                        email: emailcontroller.text,
                      ))));
          setState(() {
            _state = false;
          });
        }
      } else {
        setState(() {
          _state = false;
        });
        showTopSnackBar(
          Overlay.of(context)!,
          CustomSnackBar.error(
            message: 'Email belum terdaftar',
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
