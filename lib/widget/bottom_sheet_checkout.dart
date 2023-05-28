import 'dart:convert';
import 'package:absensi/pages/home/navbar.dart';
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
import 'loading_presensi.dart';

class BottomSheetCheckOut extends StatefulWidget {
  const BottomSheetCheckOut({Key? key}) : super(key: key);

  @override
  State<BottomSheetCheckOut> createState() => _BottomSheetCheckOutState();
}

class _BottomSheetCheckOutState extends State<BottomSheetCheckOut> {
  int? radiusUser;
  int? responsePresensiKeluar;

  Future<void> presensiKeluar({required BuildContext context}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('server');
      int? id = prefs.getInt('idPegawai');
      int? idPresensi = prefs.getInt('idPresensi');
      String? tanggalPresensi = prefs.getString('tanggalPresensi');
      final msg = jsonEncode({
        "id_user": id,
        "id_presensi" : idPresensi,
        "tanggal_presensi": tanggalPresensi,
      });
      print(DateTime.now().millisecondsSinceEpoch.toString());
      var response = await http.put(Uri.parse('$baseUrl/presensikeluar'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          },
          body: msg);
      print(response.body);
      responsePresensiKeluar = response.statusCode;
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
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12, bottom: 30),
              height: 5,
              width: 80,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFEBEBEB)),
            ),
          ),
          Text(
            'Lokasi Kamu Sekarang',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          SizedBox(
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
                  OfficeModel _office = snapshot.data!;
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin:
                              EdgeInsets.only(top: 20, left: 22, bottom: 20),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/Google Maps.svg',
                                width: 50,
                                height: 50,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _office.data.namaKantor,
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      _office.data.alamat,
                                      style: TextStyle(
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
                                    double.parse(_office.data.latitude),
                                    double.parse(_office.data.longitude),
                                    resultLocation.perangkatLatitude,
                                    resultLocation.perangkatLongitude,
                                  );

                                  print("Jarak antara dua titik adalah: " +
                                      distanceInMeters.toString() +
                                      " meter");
                                  radiusUser = distanceInMeters.toInt();
                                  return distanceInMeters.toInt();
                                }

                                return Container(
                                  margin: EdgeInsets.only(
                                      top: 20, left: 22, bottom: 20),
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
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
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                              color: Color(0xFF4285F4),
                                            ),
                                          ),
                                          Text(
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
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              resultLocation.place,
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              resultLocation.nameLocation,
                                              style: TextStyle(
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
                                return SizedBox();
                              }
                            })),
                      ],
                    ),
                  );
                } else {
                  return SizedBox();
                }
              })),
          SizedBox(
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
              text: Text(
                'Refresh',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              color: Colors.white,
              textColor: Color(0xFF4285F4),
            ),
          ),
          SizedBox(
            height: 22,
          ),
          JamRealTime(),
          SizedBox(
            height: 22,
          ),
          AbsensiButton(
            onPressed: () {
              onPress(context, radiusUser!);
            },
            text: Text('CHECK OUT SEKARANG'),
            color: Color(0xFFEA4435),
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
        await presensiKeluar(context: context);
        if (responsePresensiKeluar == 200) {
          Navigator.pop(context);
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Berhasil Checkout',
            ),
          );
          // Navigator.pop(context, false);
          Navigator.pushAndRemoveUntil(
              context, MaterialPageRoute(builder: ((context) => Navbar())),(route) => false,);
        } else {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
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
        CustomSnackBar.error(
          message: 'Terjadi Kesalahan',
        ),
      );
    }
  }
}
