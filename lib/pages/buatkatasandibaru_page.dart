import 'dart:convert';
import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/model/checkkaryawan_model.dart';
import 'package:absensi/pages/connection.dart';
import 'package:absensi/pages/verif_page.dart';
import 'package:http/http.dart' as http;
import 'package:absensi/widget/absensi_button.dart';
import 'package:absensi/widget/absensi_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BuatKataSandiBaru extends StatefulWidget {
  final CheckKaryawanModel dataKaryawan;
  const BuatKataSandiBaru({super.key, required this.dataKaryawan});

  @override
  State<BuatKataSandiBaru> createState() => _BuatKataSandiBaruState();
}

class _BuatKataSandiBaruState extends State<BuatKataSandiBaru> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passAktivasiController = TextEditingController();
  TextEditingController konfirPassController = TextEditingController();
  int? responseSendOtp;
  bool _state = false;

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
    void onPressAktivasi(BuildContext context) async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _state = true;
        });
        if (passAktivasiController.text == konfirPassController.text) {
          setState(() {
            _state = true;
          });
          await sendOtp(email: widget.dataKaryawan.data.email);
          if (responseSendOtp == 200) {
            setState(() {
              _state = true;
            });
            await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => Verifikasi(
                          emailRegister: widget.dataKaryawan.data.email,
                          namaRegister: widget.dataKaryawan.data.namaLengkap,
                          passwordRegister: passAktivasiController.text,
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
          "LANJUTKAN",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: Text(
                      'Buat Kata Sandi',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nama Lengkap',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 11,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.dataKaryawan.data.namaLengkap,
                        style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Alamat',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 11,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.dataKaryawan.data.alamat,
                        style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Agama',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 11,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.dataKaryawan.data.agama,
                        style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'No Hp',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 11,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.dataKaryawan.data.noHp,
                        style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Pendidikan',
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 11,
                            color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        widget.dataKaryawan.data.pendidikan,
                        style: const TextStyle(
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
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
                            } else if (value.length < 8) {
                              return 'Password Minimal 8 Karakter';
                            }
                            return null;
                          },
                          controller: passAktivasiController,
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
                            onPressAktivasi(context);
                          },
                          text: setUpButtonChild(),
                          textColor: Colors.white,
                          color: Color(0xFF4285F4),
                        ),
                      ],
                    ),
                  ),
                ),
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
