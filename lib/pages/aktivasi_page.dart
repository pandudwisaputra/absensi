// ignore_for_file: depend_on_referenced_packages, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:absensi/model/check_karyawan_model.dart';
import 'package:absensi/pages/buatkatasandibaru_page.dart';
import 'package:absensi/pages/login_page.dart';
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

class AktivasiPage extends StatefulWidget {
  const AktivasiPage({super.key});

  @override
  State<AktivasiPage> createState() => _AktivasiPageState();
}

class _AktivasiPageState extends State<AktivasiPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailAktivasiController = TextEditingController();
  TextEditingController kodeAktivasiController = TextEditingController();
  int? responseKaryawanCheck;
  String? responseDataKaryawan;
  int? responseUserCheck;
  String? responseDataUser;
  bool _state = false;
  CheckKaryawanModel? dataKaryawan;

  Future<void> karyawanCheck(
      {required String email, required String idKaryawan}) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      var response = await http.get(
          Uri.parse('$baseUrl/karyawancheck/$email/$idKaryawan'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          });
      print(response.body);
      if (response.statusCode == 200) {
        dataKaryawan = CheckKaryawanModel.fromJson(jsonDecode(response.body));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('idKaryawan', dataKaryawan!.data.idKaryawan);
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

  Future<void> userCheck(
      {required String email, required String idKaryawan}) async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');

      var response = await http
          .get(Uri.parse('$baseUrl/usercheck/$email/$idKaryawan'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      print(response.body);
      if (response.statusCode == 200) {
        responseUserCheck = response.statusCode;
      } else {
        var decode = FalseModel.fromJson(jsonDecode(response.body));
        responseUserCheck = decode.code;
        responseDataUser = decode.data;
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

  @override
  Widget build(BuildContext context) {
    bool validateEmail(String email) {
      String pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = RegExp(pattern);
      return regex.hasMatch(email);
    }

    void onPressAktivasi(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _state = true;
        });
        await karyawanCheck(
            email: emailAktivasiController.text,
            idKaryawan: kodeAktivasiController.text);
        print(responseKaryawanCheck);
        if (responseKaryawanCheck == 200) {
          setState(() {
            _state = true;
          });
          await userCheck(
              email: emailAktivasiController.text,
              idKaryawan: kodeAktivasiController.text);
          if (responseUserCheck == 200) {
            setState(() {
              _state = true;
            });
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => BuatKataSandiBaru(
                  dataKaryawan: dataKaryawan!,
                ),
              ),
            );
            setState(() {
              _state = false;
            });
          } else {
            setState(() {
              _state = false;
            });
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                message: responseDataUser!,
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
      }
    }

    Widget setUpButtonChild() {
      if (_state == false) {
        return const Text(
          "AKTIVASI",
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
                    'Aktivasi',
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
                              controller: emailAktivasiController,
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
                              }
                              return null;
                            },
                            controller: kodeAktivasiController,
                            hintText: 'Kode Pegawai',
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          AbsensiButton(
                            onPressed: () {
                              onPressAktivasi(context);
                            },
                            text: setUpButtonChild(),
                            textColor: Colors.white,
                            color: const Color(0xFF4285F4),
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
                                      builder: (context) => const LoginPage()),
                                  (route) => false,
                                );
                              },
                              text: const Text('LOGIN'),
                              color: Colors.white,
                              textColor: const Color(0xFF4285F4),
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
