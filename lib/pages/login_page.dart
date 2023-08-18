// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously, unused_import

import 'dart:async';
import 'dart:convert';

import 'package:absensi/model/check_status_karyawan_model.dart';
import 'package:absensi/model/false_model.dart';
import 'package:absensi/model/smartphonecheck_model.dart';
import 'package:absensi/pages/lupakatasandi_page.dart';
import 'package:absensi/pages/aktivasi_page.dart';
import 'package:absensi/widget/absensi_button.dart';
import 'package:absensi/widget/absensi_textfield.dart';
import 'package:absensi/pages/home/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_identifier/flutter_device_identifier.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../helper/exception_handler.dart';
import '../model/login_model.dart';
import 'connection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  int? status;
  int? statusKaryawan;
  String? dataStatusKaryawan;
  int? statusSmartphone;
  String? dataAndroidIdSmartphone;
  bool? _state = false;
  String? _androidId;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String androidId;
    try {
      androidId = await FlutterDeviceIdentifier.androidID;
    } on PlatformException {
      androidId = 'Failed to get android ID.';
    }
    if (!mounted) return;

    setState(() {
      _androidId = androidId;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> loginPegawai(
        {required String email, required String password}) async {
      try {
        final msg = jsonEncode({"email": email, "password": password});
        var response = await http.post(Uri.parse('http://url/api/login'),
            headers: {
              'X-API-Key': "12345678",
              'Accept': "application/json",
            },
            body: msg);
        status = response.statusCode;
        if (response.statusCode == 200) {
          var decode = LoginModel.fromJson(jsonDecode(response.body));
          int idPegawai = decode.data.idUser;
          SharedPreferences prefsId = await SharedPreferences.getInstance();
          await prefsId.setInt('idPegawai', idPegawai);
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

    Future<void> statusKaryawanCheck({required String email}) async {
      try {
        var response = await http.get(
            Uri.parse('http://url/api/statuskaryawancheck/$email'),
            headers: {
              'X-API-Key': "12345678",
              'Accept': "application/json",
            });
        statusKaryawan = response.statusCode;
        if (response.statusCode == 200) {
          var decode =
              CheckStatusKaryawanModel.fromJson(jsonDecode(response.body));
          dataStatusKaryawan = decode.data.statusKaryawan;
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

    Future<void> smartphoneCheck() async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? idUser = prefs.getInt('idPegawai');
        var response = await http
            .get(Uri.parse('http://url/api/smartphonecheck/$idUser'), headers: {
          'X-API-Key': "12345678",
          'Accept': "application/json",
        });
        statusSmartphone = response.statusCode;
        if (response.statusCode == 200) {
          var decode = SmartphoneCheckModel.fromJson(jsonDecode(response.body));
          dataAndroidIdSmartphone = decode.data.androidId;
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

    bool validateEmail(String email) {
      String pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    void onPressLogin(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        if (mounted) {
          setState(() {
            _state = true;
          });
        }
        await loginPegawai(
          email: emailcontroller.text,
          password: passcontroller.text,
        );
        if (status == 200) {
          if (mounted) {
            setState(() {
              _state = true;
            });
          }
          await statusKaryawanCheck(email: emailcontroller.text);
          if (statusKaryawan == 200) {
            setState(() {
              _state = true;
            });
            if (dataStatusKaryawan == 'active') {
              setState(() {
                _state = true;
              });
              await smartphoneCheck();
              if (statusSmartphone == 200) {
                setState(() {
                  _state = true;
                });
                if (dataAndroidIdSmartphone == _androidId) {
                  await Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => const Navbar()),
                    (route) => false,
                  );
                  setState(() {
                    _state = false;
                  });
                  SharedPreferences prefsId =
                      await SharedPreferences.getInstance();
                  await prefsId.setBool('isLoggedIn', true);
                } else {
                  setState(() {
                    _state = false;
                  });
                  showTopSnackBar(
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message: 'Mohon Login Dengan Smartphone Pribadi',
                    ),
                  );
                }
              }
            } else {
              setState(() {
                _state = false;
              });
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: 'Akun Anda Telah Dinonaktifkan',
                ),
              );
            }
          }
        } else {
          setState(() {
            _state = false;
          });
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: 'Email Atau Password Salah',
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
        return const Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        );
      } else {
        return const SizedBox(
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
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Login',
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
                    child: Column(children: [
                      AbsensiTextfield(
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
                        controller: passcontroller,
                        hintText: 'Password',
                        obscureText: true,
                        obscuringCharacter: '*',
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const LupaKataSandi(),
                              ),
                            );
                          },
                          child: const Text(
                            'Lupa Kata Sandi?',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AbsensiButton(
                        onPressed: () {
                          if (_state == false) {
                            onPressLogin(context);
                          }
                        },
                        text: setUpButtonChild(),
                        color: const Color(0xFF4285F4),
                        textColor: Colors.white,
                      ),
                      const SizedBox(
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
                                    builder: (context) => const AktivasiPage()),
                                (route) => false,
                              );
                            },
                            text: const Text('AKTIVASI'),
                            color: Colors.white,
                            textColor: const Color(0xFF4285F4),
                          )),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        body: content(),
      ),
    );
  }
}
