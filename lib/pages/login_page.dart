import 'dart:async';
import 'dart:convert';

import 'package:absensi/pages/lupakatasandi_page.dart';
import 'package:absensi/pages/register_page.dart';
import 'package:absensi/widget/absensi_button.dart';
import 'package:absensi/widget/absensi_textfield.dart';
import 'package:absensi/pages/home/navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  bool? _state = false;

  @override
  Widget build(BuildContext context) {
    Future<void> loginPegawai(
        {required String email, required String password}) async {
      try {
        SharedPreferences server = await SharedPreferences.getInstance();
        String? baseUrl = server.getString('server');
        final msg = jsonEncode({"email": email, "password": password});
        var response = await http.post(Uri.parse('$baseUrl/login'),
            headers: {
              'X-API-Key': "12345678",
              'Accept': "application/json",
            },
            body: msg);
        print(response.body);
        status = response.statusCode;
        if (response.statusCode == 200) {
          var decode = LoginModel.fromJson(jsonDecode(response.body));
          int idPegawai = decode.data.idUser;
          print('id pegawai = $idPegawai');
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
        if(mounted){
          setState(() {
          _state = true;
        });
        }
        
        await loginPegawai(
          email: emailcontroller.text,
          password: passcontroller.text,
        );
        if (status == 200) {
          setState(() {
            _state = true;
          });
          await Navigator.pushAndRemoveUntil(context,
              CupertinoPageRoute(builder: (context) => const Navbar()),(route) => false,);
          setState(() {
            _state = false;
          });
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
        return new Text(
          "LOGIN",
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
                                builder: (context) => LupaKataSandi(),
                              ),
                            );
                          },
                          child: Text(
                            'Lupa Kata Sandi?',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AbsensiButton(
                        onPressed: () {
                          if (_state == false) {
                            onPressLogin(context);
                          }
                        },
                        text: setUpButtonChild(),
                        color: Color(0xFF4285F4),
                        textColor: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xFF4285F4))),
                          child: AbsensiButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const RegisterPage()),(route) => false,);
                            },
                            text: Text('REGISTER'),
                            color: Colors.white,
                            textColor: Color(0xFF4285F4),
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

    return Scaffold(
      body: content(),
    );
  }
}
