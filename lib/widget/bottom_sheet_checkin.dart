// ignore_for_file: depend_on_referenced_packages, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:absensi/model/presensi_model.dart';
import 'package:absensi/pages/home/navbar.dart';
import 'package:absensi/widget/loading_presensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:absensi/model/name_location.dart';
import 'package:absensi/model/office_model.dart';
import 'package:absensi/widget/absensi_jam_realtime.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../helper/exception_handler.dart';
import '../pages/connection.dart';
import 'absensi_button.dart';

class BottomSheetCheckIn extends StatefulWidget {
  const BottomSheetCheckIn({Key? key}) : super(key: key);

  @override
  State<BottomSheetCheckIn> createState() => _BottomSheetCheckInState();
}

class _BottomSheetCheckInState extends State<BottomSheetCheckIn> {
  int? radiusUser;
  int? responsePresensiMasuk;

  Future<void> presensiMasuk({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('server');
      String? userLatitude = prefs.getString('userLatitude');
      String? userLongitude = prefs.getString('userLongitude');
      String? userLocation = prefs.getString('userLocation');
      int? id = prefs.getInt('idPegawai');
      String tanggalPresensi = DateTime.now().millisecondsSinceEpoch.toString();
      prefs.setString('tanggalPresensi', tanggalPresensi);
      var msg = jsonEncode({
        "id_user": id,
        "tanggal_presensi": tanggalPresensi,
        "latitude": userLatitude,
        "longitude": userLongitude,
        "alamat": userLocation
      });
      var response = await http.post(Uri.parse('$baseUrl/presensimasuk'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          },
          body: msg);
      print(response.body);
      responsePresensiMasuk = response.statusCode;
      if (response.statusCode == 200) {
        PresensiModel presensi =
            PresensiModel.fromJson(jsonDecode(response.body));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('idPresensi', presensi.data.idPresensi);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 30),
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFEBEBEB)),
            ),
          ),
          const Text(
            'Lokasi Kamu Sekarang',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FutureBuilder(
              future: OfficeRepository.getOffice(context),
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return shimmer(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                  );
                } else if (snapshot.hasData) {
                  OfficeModel office = snapshot.data!;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, left: 22, bottom: 20),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/Google Maps.svg',
                                width: 50,
                                height: 50,
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      office.data.namaKantor,
                                      style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      office.data.alamat,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: Color(0xFF878787),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        FutureBuilder(
                            future: LocationRepository.getLocation(context),
                            builder: ((context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return shimmer(
                                  height: 80,
                                  width: MediaQuery.of(context).size.width,
                                );
                              } else if (snapshot.hasData) {
                                LocationModel resultLocation = snapshot.data!;
                                int getJarak() {
                                  double distanceInMeters =
                                      Geolocator.distanceBetween(
                                    double.parse(office.data.latitude),
                                    double.parse(office.data.longitude),
                                    resultLocation.perangkatLatitude,
                                    resultLocation.perangkatLongitude,
                                  );

                                  print(
                                      "Jarak antara dua titik adalah: $distanceInMeters meter");
                                  radiusUser = distanceInMeters.toInt();
                                  return distanceInMeters.toInt();
                                }

                                return Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, left: 22, bottom: 20),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          const Text(
                                            'Jarak',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Color(0xFF4285F4),
                                            ),
                                          ),
                                          Text(
                                            // getJarak().bitLength > 2
                                            //     ? '${(getJarak() / 1000).toStringAsFixed(1)} km'
                                            //     : '${getJarak()} m',
                                            '${getJarak()} m',
                                            style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: Color(0xFF4285F4),
                                            ),
                                          ),
                                          const Text(
                                            'Dari Kantor',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Color(0xFF4285F4),
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              resultLocation.place,
                                              style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              resultLocation.nameLocation,
                                              style: const TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 11,
                                                color: Color(0xFF878787),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return const SizedBox();
                              }
                            })),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              })),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF4285F4))),
            child: AbsensiButton(
              onPressed: () {
                setState(() {});
              },
              text: const Text(
                'Refresh',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              color: Colors.white,
              textColor: const Color(0xFF4285F4),
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          const JamRealTime(),
          const SizedBox(
            height: 22,
          ),
          AbsensiButton(
            onPressed: () {
              onPress(context, radiusUser!);
            },
            text: const Text('CHECK IN SEKARANG'),
            color: const Color(0xFF00AC47),
            textColor: Colors.white,
          )
        ],
      ),
    );
  }

  void onPress(BuildContext context, int radiusUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? radius = prefs.getInt('radius');
    if (radius != null) {
      if (radiusUser <= radius) {
        pleaseWait(context);
        await presensiMasuk(context: context);
        if (responsePresensiMasuk == 200) {
          Navigator.pop(context, true);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Berhasil Checkin',
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => const Navbar())),
            (route) => false,
          );
        } else {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: 'Terjadi Kesalahan',
            ),
          );
        }
      } else {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: 'Mohon Memasuki Radius $radius m',
          ),
        );
      }
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Terjadi Kesalahan',
        ),
      );
    }
  }
}