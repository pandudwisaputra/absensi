import 'dart:convert';
import 'package:absensi/model/iduser_model.dart';
import 'package:absensi/model/otp_model.dart';
import 'package:absensi/page/buat_katasandi_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import 'connection.dart';

class VerifLupaPw extends StatefulWidget {
  final String email;
  const VerifLupaPw({super.key, required this.email});

  @override
  _VerifLupaPwState createState() => _VerifLupaPwState();
}

class _VerifLupaPwState extends State<VerifLupaPw> {
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  int? responseOtpValidation;
  String? responseDataOtp;
  int? responseGetIdUser;
  int? id;
  bool _state = false;
  bool timerWidget = true;

  Future<void> sendOtp() async {
    try {
      SharedPreferences server = await SharedPreferences.getInstance();
      String? baseUrl = server.getString('server');
      SharedPreferences email = await SharedPreferences.getInstance();
      String? emailRegister = email.getString('emailRegister');
      final msg = jsonEncode(
        {
          "email": emailRegister,
        },
      );
      var response = await http.post(Uri.parse('$baseUrl/sendotp'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          },
          body: msg);
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

  Future<void> otpValidation({
    required String email,
    required String otp,
  }) async {
    SharedPreferences server = await SharedPreferences.getInstance();
    String? baseUrl = server.getString('server');
    try {
      final msg = jsonEncode(
        {
          "email": email,
          "otp": otp,
        },
      );
      var response = await http.post(Uri.parse('$baseUrl/otpvalidation'),
          headers: {
            "X-API-Key": "12345678",
            'Accept': "application/json",
          },
          body: msg);
      print(response.body);

      if (response.statusCode == 200) {
        var decode = OtpModel.fromJson(jsonDecode(response.body));
        responseOtpValidation = decode.code;
        responseDataOtp = decode.data.status;
      } else {
        var decode = OtpSalahModel.fromJson(jsonDecode(response.body));
        responseOtpValidation = decode.code;
        responseDataOtp = decode.data;
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

  Future<void> getIdUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('server');
      var response = await http
          .get(Uri.parse('$baseUrl/getiduser/${widget.email}'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      print(response.body);
      responseGetIdUser = response.statusCode;
      if (response.statusCode == 200) {
        var decode = IdUserModel.fromJson(jsonDecode(response.body));
        id = decode.data.idUser;
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 52),
              child: Image.asset(
                "assets/png/verif.png",
                width: 293,
                height: 293,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(
                'Verifikasi Akun',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xFF4285F4),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                'Cek email kamu untuk mendapatkan kode\nverifikasi dari akun',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Color(0xffA8A8A8),
                  fontSize: 11,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 42, right: 42, top: 23),
              child: Center(
                child: PinCodeTextField(
                  length: 4,
                  backgroundColor: Colors.white,
                  keyboardType: TextInputType.numberWithOptions(),
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 54,
                      fieldWidth: 57,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      inactiveColor: Color(0x26000000),
                      activeColor: Color(0x26000000)),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: textEditingController,
                  onCompleted: (v) {
                    debugPrint("Completed");
                  },
                  onChanged: (value) {
                    debugPrint(value);
                    setState(() {
                      currentText = value;
                    });
                  },
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: timerWidget
                  ? TweenAnimationBuilder<Duration>(
                      duration: const Duration(minutes: 3),
                      tween: Tween(
                          begin: const Duration(minutes: 3),
                          end: Duration.zero),
                      onEnd: () {
                        setState(() {
                          timerWidget = false;
                        });
                      },
                      builder: (BuildContext context, Duration value,
                          Widget? child) {
                        final minutes = value.inMinutes;
                        final seconds = value.inSeconds % 60;
                        return Text(
                          'Mohon tunggu dalam $minutes:$seconds untuk kirim ulang',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            color: Color(0xffA8A8A8),
                            fontSize: 12,
                          ),
                        );
                      })
                  : TextButton(
                      onPressed: () {
                        setState(() {
                          timerWidget = true;
                        });
                        sendOtp();
                      },
                      child: Text(
                        'Kirim ulang kode',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color(0xFF4285F4),
                          fontSize: 12,
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 32,
            ),
            RawMaterialButton(
              onPressed: () {
                if (_state == false) {
                  onPress(context);
                }
              },
              fillColor: Color(0xFF4285F4),
              constraints: BoxConstraints(minHeight: 49, minWidth: 128),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: setUpButtonChild(),
            ),
          ],
        ),
      ),
    );
  }

  Widget setUpButtonChild() {
    if (_state == false) {
      return new Text(
        "Verifikasi",
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Poppins',
          fontSize: 15,
          fontWeight: FontWeight.w500,
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
    if (textEditingController.text != "") {
      setState(() {
        _state = true;
      });
      await otpValidation(email: widget.email, otp: textEditingController.text);
      if (responseOtpValidation == 200) {
        setState(() {
          _state = true;
        });
        if (responseDataOtp == "Success") {
          setState(() {
            _state = true;
          });
          await getIdUser();
          if (responseGetIdUser == 200) {
            setState(() {
              _state = true;
            });
            await Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => BuatKataSandi(
                          email: widget.email,
                          id: id!,
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
            Overlay.of(context)!,
            CustomSnackBar.error(
              message: responseDataOtp!,
            ),
          );
        }
      } else {
        setState(() {
          _state = false;
        });
        showTopSnackBar(
          Overlay.of(context)!,
          CustomSnackBar.error(
            message: responseDataOtp!,
          ),
        );
      }
    } else {
      setState(() {
        _state = false;
      });
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: 'Kode Verifikasi Kosong',
        ),
      );
    }
  }
}
