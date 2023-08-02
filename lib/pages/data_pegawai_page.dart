// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, depend_on_referenced_packages

import 'dart:convert';

import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/model/check_karyawan_model.dart';
import 'package:absensi/model/check_recognition_model.dart';
import 'package:absensi/model/recognition.dart';
import 'package:absensi/pages/add_face_recognition_page.dart';
import 'package:absensi/pages/connection.dart';
import 'package:absensi/pages/ubah_katasandi_page.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:absensi/widget/loading_presensi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DataPegawaiPage extends StatefulWidget {
  final String ava;
  const DataPegawaiPage({super.key, required this.ava});

  @override
  State<DataPegawaiPage> createState() => _DataPegawaiPageState();
}

class _DataPegawaiPageState extends State<DataPegawaiPage> {
  int? responseRegister;
  @override
  Widget build(BuildContext context) {
    Future<void> registerRecognition({
      required String name,
      required Rect location,
      required List<double> embeddings,
      required double distance,
    }) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? key = prefs.getString('namaLengkap');
      int? idPegawai = prefs.getInt('idPegawai');
      try {
        var response = await http.post(
          Uri.parse('http://api2.myfin.id:4500/api/recognition'),
          headers: {
            'X-API-Key': '12345678',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'id_user': idPegawai,
            'key': key,
            'name': name,
            'location_left': location.left.toString(),
            'location_top': location.top.toString(),
            'location_right': location.right.toString(),
            'location_bottom': location.bottom.toString(),
            'embeddings': embeddings.toString(),
            'distance': distance.toString(),
          }),
        );
        setState(() {
          responseRegister = response.statusCode;
        });
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

    void onPress() async {
      final result = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => const AddFaceRecognitionPage()));
      if (result != null) {
        pleaseWait(context);
        final recognition = result as Recognition;
        await registerRecognition(
          name: recognition.name,
          location: recognition.location,
          embeddings: recognition.embeddings,
          distance: recognition.distance,
        );
        if (responseRegister == 200) {
          Navigator.pop(context, true);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: 'Berhasil Menambahkan Data',
            ),
          );
        } else {
          Navigator.pop(context, true);
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: 'Gagal Menambahkan Data',
            ),
          );
        }
      }
    }

    AppBar appBar() {
      return AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Data pegawai',
          style: TextStyle(
            fontFamily: 'Open Sans',
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      );
    }

    Widget content() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 25,
          left: 40,
          right: 40,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: KaryawanRepository.getKaryawan(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: circleShimmer(
                              height: 160,
                              width: 160,
                            ),
                          ),
                          const SizedBox(
                            height: 76,
                          ),
                          shimmer(
                            height: 19,
                            width: 100,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          shimmer(
                            height: 50,
                            width: double.infinity,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          shimmer(
                            height: 19,
                            width: 100,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          shimmer(
                            height: 50,
                            width: double.infinity,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          shimmer(
                            height: 19,
                            width: 100,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          shimmer(
                            height: 50,
                            width: double.infinity,
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                        ],
                      );
                    } else if (snapshot.hasData) {
                      CheckKaryawanModel karyawan = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(widget.ava != '-'
                                  ? widget.ava
                                  : 'https://firebasestorage.googleapis.com/v0/b/presensi-17f1d.appspot.com/o/profile_picture%2Fimage_profile.png?alt=media&token=1a3f9725-8601-4c3c-a14d-cc1a222980d9'),
                            ),
                          ),
                          const SizedBox(
                            height: 76,
                          ),
                          const Text(
                            'Nama Lengkap',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE7E7FE),
                              ),
                            ),
                            child: Text(
                              karyawan.data.namaLengkap,
                              style: const TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE7E7FE),
                              ),
                            ),
                            child: Text(
                              karyawan.data.email,
                              style: const TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          const Text(
                            'Jabatan',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE7E7FE),
                              ),
                            ),
                            child: Text(
                              karyawan.data.jabatan,
                              style: const TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  }),
              FutureBuilder(
                future: RecognitionRepository.getRecognition(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmer(
                          height: 19,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        shimmer(
                          height: 50,
                          width: double.infinity,
                        ),
                      ],
                    );
                  } else if (snapshot.hasData) {
                    bool isAvailable = snapshot.data!;
                    if (isAvailable == true) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Face Recognition',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE7E7FE),
                              ),
                            ),
                            child: const Text(
                              'Terdaftar',
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Face Recognition',
                            style: TextStyle(
                              fontFamily: 'Open Sans',
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 11,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFE7E7FE),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Belum Terdaftar',
                                  style: TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    onPress();
                                  },
                                  child: const Text(
                                    'Tambah',
                                    style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFFFB575),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.warning,
                                size: 15,
                                color: Colors.redAccent,
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Flexible(
                                child: Text(
                                  'Tambahkan data untuk melakukan presensi',
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Open Sans',
                                      fontSize: 12,
                                      color: Colors.redAccent),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                'Password',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFE7E7FE),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '********',
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: ((context) => const UbahKataSandi())));
                      },
                      child: const Text(
                        'Ubah',
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFB575),
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        appBar: appBar(),
        body: content(),
      ),
    );
  }
}
