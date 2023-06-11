import 'dart:async';
import 'dart:io';

import 'package:absensi/model/office_model.dart';
import 'package:absensi/model/profile_model.dart';
import 'package:absensi/pages/login_page.dart';
import 'package:absensi/widget/absensi_button.dart';
import 'package:absensi/widget/absensi_button_dashboard.dart';
import 'package:absensi/widget/absensi_jam_realtime.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:absensi/apiLoc/location_service.dart';
import 'package:absensi/widget/absensi_jam.dart';
import 'package:absensi/widget/click_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  GoogleMapController? mapController;
  LocationUpdater locationUpdater = LocationUpdater();

  /// initialize state.
  @override
  void initState() {
    super.initState();
    locationUpdater.startLocationUpdates();
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow < 12) {
      return 'Selamat Pagi 👋';
    } else if ((timeNow >= 12) && (timeNow < 15)) {
      return 'Selamat Siang 👋';
    } else if ((timeNow >= 15) && (timeNow < 18)) {
      return 'Selamat Sore 👋';
    } else {
      return 'Selamat Malam 👋';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 27, right: 27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: ProfileRepository.getProfile(context),
                  builder: (context, snapshort) {
                    if (snapshort.connectionState == ConnectionState.waiting) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              shimmer(
                                height: 15,
                                width: MediaQuery.of(context).size.width - 122,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              shimmer(
                                height: 19,
                                width: MediaQuery.of(context).size.width - 122,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          circleShimmer(height: 48, width: 48),
                        ],
                      );
                    } else if (snapshort.hasData) {
                      ProfileModel profile = snapshort.data!;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greetingMessage(),
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                profile.data.nama,
                                style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              clickImage(
                                  context,
                                  profile.data.avatar == '-'
                                      ? 'https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/profile_picture%2Fimage_profile.png?alt=media&token=1a3f9725-8601-4c3c-a14d-cc1a222980d9'
                                      : profile.data.avatar);
                            },
                            child: CircleAvatar(
                              radius: 24,
                              backgroundImage: NetworkImage(
                                profile.data.avatar == '-'
                                    ? 'https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/profile_picture%2Fimage_profile.png?alt=media&token=1a3f9725-8601-4c3c-a14d-cc1a222980d9'
                                    : profile.data.avatar,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
              const SizedBox(
                height: 47,
              ),
              const JamRealTime(),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: OfficeRepository.getOffice(context),
                builder: ((context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmer(
                            height: 250,
                            width: MediaQuery.of(context).size.width),
                        const SizedBox(
                          height: 20,
                        ),
                        shimmer(
                          height: 15,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        shimmer(
                          height: 68,
                          width: MediaQuery.of(context).size.width,
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Row(
                          children: [
                            shimmer(
                              height: 56,
                              width: MediaQuery.of(context).size.width / 2 - 32,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            shimmer(
                              height: 56,
                              width: MediaQuery.of(context).size.width / 2 - 32,
                            )
                          ],
                        )
                      ],
                    );
                  } else if (snapshot.hasData) {
                    OfficeModel office = snapshot.data!;
                    bool isFirstData = true;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder(
                          stream: locationUpdater.locationStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              double latitude = locationUpdater.latitude;
                              double longitude = locationUpdater.longitude;
                              bool isMockLocation = snapshot.data!;
                              if (kDebugMode) {
                                print('ini isMockLocation : $isMockLocation');
                                print('ini isFirstData : $isFirstData');
                              }
                              if (isMockLocation == true &&
                                  isFirstData == false) {
                                Future.microtask(() async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isLoggedIn', false);
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => const LoginPage(),
                                      ),
                                      (route) => false,
                                    );
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) => Dialog(
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                        insetPadding: const EdgeInsets.all(10),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: <Widget>[
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 40),
                                              padding: const EdgeInsets.all(20),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    'Ada yang ketahuan tidak jujur nih. Kamu tidak akan bisa melakukan presensi jika masih menggunakan lokasi palsu :p',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  AbsensiButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      exit(0);
                                                    },
                                                    color:
                                                        const Color(0xFF4285F4),
                                                    textColor: Colors.white,
                                                    paddingVertical: 10,
                                                    text: const Text(
                                                      'Tutup',
                                                      style: TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                  });
                                });
                              }
                              isFirstData = false;

                              return Column(
                                children: [
                                  Container(
                                    height: 250,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      ),
                                      child: GoogleMap(
                                        myLocationEnabled: true,
                                        onMapCreated: (controller) =>
                                            mapController = controller,
                                        initialCameraPosition: CameraPosition(
                                          target: LatLng(latitude, longitude),
                                          zoom: 17,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId: const MarkerId("source"),
                                            position: LatLng(
                                                double.parse(
                                                    office.data.latitude),
                                                double.parse(
                                                    office.data.longitude)),
                                          ),
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return shimmer(
                                  height: 250,
                                  width: MediaQuery.of(context).size.width);
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Lokasi Kantor',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              decoration: BoxDecoration(
                                  color: const Color.fromRGBO(245, 245, 245, 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/svg/Google Maps.svg'),
                                  const SizedBox(
                                    width: 23,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          office.data.namaKantor,
                                          style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          office.data.alamat,
                                          style: const TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Row(
                          children: [
                            AbsensiJam(
                              title: 'Jam Masuk',
                              jam: '${office.data.jamMasuk} WIB',
                              color: const Color.fromRGBO(0, 172, 71, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AbsensiJam(
                              title: 'Jam Pulang',
                              jam: '${office.data.jamPulang} WIB',
                              color: const Color.fromRGBO(234, 68, 53, 1),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              const Buttondashboard()
            ],
          ),
        ),
      ),
    );
  }
}
