import 'package:absensi/model/presensi_check_model.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:absensi/widget/bottom_sheet_checkin_tidak_masuk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'absensi_button.dart';
import 'bottom_sheet_checkin.dart';
import 'bottom_sheet_checkout.dart';

class Buttondashboard extends StatefulWidget {
  const Buttondashboard({super.key});

  @override
  State<Buttondashboard> createState() => _ButtondashboardState();
}

class _ButtondashboardState extends State<Buttondashboard> {
  @override
  Widget build(BuildContext context) {
    Future<void> showSuccessDialog() async {
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
                                builder: (BuildContext context) =>
                                    const BottomSheetCheckIn(),
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
                onPressed: () {
                  showSuccessDialog();
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
                SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
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
