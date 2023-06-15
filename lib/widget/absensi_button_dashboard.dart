

// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/model/check_status_karyawan_model.dart';
import 'package:absensi/model/presensi_check_model.dart';
import 'package:absensi/pages/connection.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:absensi/widget/bottom_sheet_checkin_tidak_masuk.dart';
import 'package:absensi/widget/loading_presensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:http/http.dart' as http;
import 'absensi_button.dart';
import 'bottom_sheet_checkin.dart';
import 'bottom_sheet_checkout.dart';

class Buttondashboard extends StatefulWidget {
  const Buttondashboard({super.key});

  @override
  State<Buttondashboard> createState() => _ButtondashboardState();
}

class _ButtondashboardState extends State<Buttondashboard> {
  int? statusKaryawan;
  String? dataStatusKaryawan;
  @override
  Widget build(BuildContext context) {
    Future<void> statusKaryawanCheck() async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? email = prefs.getString('email');
        var response = await http.get(
            Uri.parse(
                'http://api.myfin.id:4000/api/statuskaryawancheck/$email'),
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

    Future<void> akunDinonaktifkanDialog() {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light));
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Info penting!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Akunmu telah dinonaktifkan sehingga kamu tidak bisa melakukan presensi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AbsensiButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isLoggedIn', false);
                                                      exit(0);
                      },
                      color: const Color(0xFF4285F4),
                      textColor: Colors.white,
                      paddingVertical: 10,
                      text: const Text(
                        'Tutup',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Future<void> showSuccessDialog() {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light));
      return showDialog(
        context: context,
        builder: (BuildContext context) => SizedBox(
          width: MediaQuery.of(context).size.width - (2 * 30),
          child: AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Pilih Keterangan :',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextButton(
                            onPressed: () {
                              SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                      statusBarColor: Colors.transparent,
                                      systemNavigationBarColor: Colors.white,
                                      statusBarIconBrightness:
                                          Brightness.light));
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return const BottomSheetCheckIn();
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Masuk',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: TextButton(
                            onPressed: () {
                              SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                      statusBarColor: Colors.transparent,
                                      systemNavigationBarColor: Colors.white,
                                      statusBarIconBrightness:
                                          Brightness.light));
                              Navigator.pop(context);
                              const SizedBox();
                              showModalBottomSheet(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25),
                                  ),
                                ),
                                builder: (BuildContext context) =>
                                    const BottomSheetCheckInTidakMasuk(),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Tidak Masuk',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return FutureBuilder(
      future: PresensiCheckRepository.getPresensiCheck(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return shimmer(
            height: 60,
            width: MediaQuery.of(context).size.width,
          );
        } else if (snapshot.hasData) {
          PresensiCheckModel presensiCheck = snapshot.data!;
          int currentMillis = int.parse(presensiCheck.data.tanggalPresensi);
          DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(currentMillis);
          String tanggalPresensi =
              "${dateTime.day}-${dateTime.month}-${dateTime.year}";

          DateTime now = DateTime.now();
          String tanggalSekarang = "${now.day}-${now.month}-${now.year}";

          if (presensiCheck.data.status == 'Selesai') {
            if (tanggalSekarang != tanggalPresensi) {
              return AbsensiButton(
                onPressed: () async {
                  pleaseWait(context);
                  await statusKaryawanCheck();
                  Navigator.pop(context);
                  if (statusKaryawan == 200) {
                    if (dataStatusKaryawan == 'active') {
                      showSuccessDialog();
                    } else {
                      akunDinonaktifkanDialog();
                    }
                  }
                },
                text: const Text('CHECK IN'),
                color: const Color(0xFF00AC47),
                textColor: Colors.white,
              );
            } else {
              return AbsensiButton(
                onPressed: () {
                  showTopSnackBar(
                    Overlay.of(context),
                    const CustomSnackBar.error(
                      message: 'Kamu Sudah Presensi Hari Ini',
                    ),
                  );
                },
                text: const Text('CHECK IN'),
                color: const Color(0xFF00AC47),
                textColor: Colors.white,
              );
            }
          } else {
            return AbsensiButton(
              onPressed: () async {
                await statusKaryawanCheck();
                if (statusKaryawan == 200) {
                  if (dataStatusKaryawan == 'active') {
                    SystemChrome.setSystemUIOverlayStyle(
                        const SystemUiOverlayStyle(
                            statusBarColor: Colors.transparent,
                            systemNavigationBarColor: Colors.white,
                            statusBarIconBrightness: Brightness.light));
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      builder: (BuildContext context) =>
                          const BottomSheetCheckOut(),
                    );
                  } else {
                    akunDinonaktifkanDialog();
                  }
                }
              },
              text: const Text('CHECK OUT'),
              color: const Color(0xFFEA4435),
              textColor: Colors.white,
            );
          }
        } else {
          return AbsensiButton(
            onPressed: () {
              showSuccessDialog();
            },
            text: const Text('CHECK IN'),
            color: const Color(0xFF00AC47),
            textColor: Colors.white,
          );
        }
      },
    );
  }
}
