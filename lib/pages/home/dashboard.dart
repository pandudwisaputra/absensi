import 'package:absensi/model/office_model.dart';
import 'package:absensi/model/profile_model.dart';
import 'package:absensi/widget/absensi_button_dashboard.dart';
import 'package:absensi/widget/absensi_jam_realtime.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:absensi/apiLoc/location_service.dart';
import 'package:absensi/apiLoc/user_location.dart';
import 'package:absensi/widget/absensi_jam.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  LocationService locationService = LocationService();
  GoogleMapController? mapController;
  bool presensiMasuk = false;

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow < 12) {
      return 'Selamat Pagi';
    } else if ((timeNow >= 12) && (timeNow < 16)) {
      return 'Selamat Siang';
    } else if ((timeNow >= 16) && (timeNow < 20)) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
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
                              SizedBox(
                                height: 5,
                              ),
                              shimmer(
                                height: 19,
                                width: MediaQuery.of(context).size.width - 122,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          circleShimmer(height: 48, width: 48),
                        ],
                      );
                    } else if (snapshort.hasData) {
                      ProfileModel _profile = snapshort.data!;
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
                                _profile.data.nama,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              _profile.data.avatar == '-'
                                  ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
                                  : _profile.data.avatar,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return SizedBox();
                    }
                  }),
              const SizedBox(
                height: 47,
              ),
              JamRealTime(),
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
                        SizedBox(
                          height: 10,
                        ),
                        shimmer(
                          height: 68,
                          width: MediaQuery.of(context).size.width,
                        ),
                        SizedBox(
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
                    OfficeModel _office = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<Userlocation>(
                            stream: locationService.locationStrem,
                            builder: (context, snapshort) {
                              if (snapshort.hasData) {
                                return Column(
                                  children: [
                                    Container(
                                      height: 250,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
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
                                            target: LatLng(
                                                snapshort.data!.latitude,
                                                snapshort.data!.longtitude),
                                            zoom: 17,
                                          ),
                                          markers: {
                                            Marker(
                                              markerId: MarkerId("source"),
                                              position: LatLng(
                                                  double.parse(
                                                      _office.data.latitude),
                                                  double.parse(
                                                      _office.data.longitude)),
                                            ),
                                          },
                                          circles: {
                                            Circle(
                                                circleId: const CircleId('ID'),
                                                center: LatLng(
                                                    snapshort.data!.latitude,
                                                    snapshort.data!.longtitude),
                                                radius: 5,
                                                fillColor: Colors.blueAccent
                                                    .withOpacity(0.5),
                                                strokeWidth: 3,
                                                strokeColor: Colors.blueAccent)
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshort.connectionState ==
                                  ConnectionState.waiting) {
                                return shimmer(
                                    height: 250,
                                    width: MediaQuery.of(context).size.width);
                              } else {
                                return SizedBox();
                              }
                            }),
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
                        Container(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                decoration: BoxDecoration(
                                    color:
                                        const Color.fromRGBO(245, 245, 245, 1),
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
                                            _office.data.namaKantor,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            _office.data.alamat,
                                            style: TextStyle(
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
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Row(
                          children: [
                            AbsensiJam(
                              title: 'Jam Masuk',
                              jam: '${_office.data.jamMasuk} WIB',
                              color: Color.fromRGBO(0, 172, 71, 1),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AbsensiJam(
                              title: 'Jam Pulang',
                              jam: '${_office.data.jamPulang} WIB',
                              color: Color.fromRGBO(234, 68, 53, 1),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              Buttondashboard()
            ],
          ),
        ),
      ),
    );
  }
}
