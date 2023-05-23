import 'dart:convert';
import 'package:absensi/model/checkkaryawan_model.dart';
import 'package:absensi/pages/login_page.dart';
import 'package:absensi/pages/verif_page.dart';
import 'package:absensi/widget/absensi_button.dart';
import 'package:absensi/widget/absensi_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helper/exception_handler.dart';
import '../model/false_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'connection.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailRegisController = TextEditingController();
  TextEditingController namaRegisController = TextEditingController();
  TextEditingController passRegisController = TextEditingController();
  TextEditingController konfirPassController = TextEditingController();
  int? responseEmailCheck;
  String? responseDataEmail;
  int? responseSendOtp;
  int? responseKaryawanCheck;
  String? responseDataKaryawan;
  bool _state = false;

  Future<void> karyawanCheck({required String email}) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      var response =
          await http.get(Uri.parse('$baseUrl/karyawancheck/$email'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      print(response.body);
      if (response.statusCode == 200) {
        var decode = CheckKaryawanModel.fromJson(jsonDecode(response.body));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('idKaryawan', decode.data.idKaryawan);
        responseKaryawanCheck = response.statusCode;
      } else {
        var decode = FalseModel.fromJson(jsonDecode(response.body));
        responseKaryawanCheck = decode.code;
        responseDataKaryawan = decode.data;
      }
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
        (route) => false,
      );
    }
  }

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
      if (response.statusCode == 200) {
        responseEmailCheck = response.statusCode;
      } else {
        var decode = FalseModel.fromJson(jsonDecode(response.body));
        responseEmailCheck = decode.code;
        responseDataEmail = decode.data;
      }
    } catch (e) {
      var error = ExceptionHandlers().getExceptionString(e);
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
        (route) => false,
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
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => ConnectionPage(
            button: true,
            error: error,
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool validateName(String value) {
      String pattern = r'^[a-zA-Z\s]+$';
      RegExp regex = new RegExp(pattern);
      return regex.hasMatch(value);
    }

    bool validateEmail(String email) {
      String pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    void onPressRegister(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _state = true;
        });
        if (passRegisController.text == konfirPassController.text) {
          setState(() {
            _state = true;
          });
          await karyawanCheck(email: emailRegisController.text);
          print(responseKaryawanCheck);
          if (responseKaryawanCheck == 200) {
            setState(() {
              _state = true;
            });
            await emailCheck(email: emailRegisController.text);
            if (responseEmailCheck == 200) {
              setState(() {
                _state = true;
              });
              await sendOtp(email: emailRegisController.text);
              List<String> kata = namaRegisController.text.split(" ");
              String namaCapitalize = "";

              for (String kataSekarang in kata) {
                namaCapitalize += kataSekarang[0].toUpperCase() +
                    kataSekarang.substring(1).toLowerCase() +
                    " ";
              }
              if (responseSendOtp == 200) {
                setState(() {
                  _state = true;
                });
                await Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => Verifikasi(
                              emailRegister: emailRegisController.text,
                              namaRegister: namaCapitalize,
                              passwordRegister: passRegisController.text,
                            )));
                setState(() {
                  _state = false;
                });
              }
            } else {
              setState(() {
                _state = false;
              });
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                  message: responseDataEmail!,
                ),
              );
            }
          } else {
            setState(() {
              _state = false;
            });
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: responseDataKaryawan!,
              ),
            );
          }
        } else {
          setState(() {
            _state = false;
          });
          showTopSnackBar(
            Overlay.of(context),
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

    Widget setUpButtonChild() {
      if (_state == false) {
        return new Text(
          "REGISTER",
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

    Widget content() {
      return SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          AbsensiTextfield(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Harus Diisi';
                              } else if (!validateName(value)) {
                                return 'Nama Hanya Boleh Mengandung Huruf Dan Spasi';
                              }
                              return null;
                            },
                            controller: namaRegisController,
                            hintText: 'Nama',
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AbsensiTextfield(
                              controller: emailRegisController,
                              hintText: 'Email',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Harus Diisi';
                                } else if (!validateEmail(value)) {
                                  return 'Masukkan Email Dengan Benar';
                                }
                                return null;
                              }),
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
                            controller: passRegisController,
                            hintText: 'Password',
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
                            controller: konfirPassController,
                            hintText: 'Konfirmasi Password',
                            obscureText: true,
                            obscuringCharacter: '*',
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AbsensiButton(
                            onPressed: () {
                              onPressRegister(context);
                            },
                            text: setUpButtonChild(),
                            textColor: Colors.white,
                            color: Color(0xFF4285F4),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: const Color(0xFF4285F4))),
                            child: AbsensiButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),(route) => false,);
                              },
                              text: Text('LOGIN'),
                              color: Colors.white,
                              textColor: Color(0xFF4285F4),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: content(),
    );
  }
}
