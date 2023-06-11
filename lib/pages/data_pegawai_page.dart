import 'package:absensi/model/check_karyawan_model.dart';
import 'package:absensi/model/check_recognition_model.dart';
import 'package:absensi/pages/add_face_recognition_page.dart';
import 'package:absensi/pages/ubah_katasandi_page.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataPegawaiPage extends StatefulWidget {
  const DataPegawaiPage({super.key});

  @override
  State<DataPegawaiPage> createState() => _DataPegawaiPageState();
}

class _DataPegawaiPageState extends State<DataPegawaiPage> {
  @override
  Widget build(BuildContext context) {
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
                              backgroundImage: NetworkImage(karyawan
                                          .data.foto !=
                                      '-'
                                  ? karyawan.data.foto
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
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                const AddFaceRecognitionPage()));
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
