import 'package:absensi/model/riwayat_model.dart';
import 'package:absensi/widget/absensi_shimmer.dart';
import 'package:absensi/widget/not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class MingguIni extends StatelessWidget {
  const MingguIni({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 38),
      child: FutureBuilder(
        future: RiwayatRepository.getData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmer(height: 15, width: 90),
                        const SizedBox(
                          height: 5,
                        ),
                        shimmer(
                            height: 100,
                            width: MediaQuery.of(context).size.width),
                        const SizedBox(
                          height: 10,
                        ),
                        shimmer(
                            height: 100,
                            width: MediaQuery.of(context).size.width),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasData) {
            List<RiwayatModel> listRiwayat = snapshot.data;
            List<RiwayatModel> resultRiwayat = [];
            DateTime now = DateTime.now();
            DateTime startOfWeek =
                now.subtract(Duration(days: now.weekday - 1));
            DateTime endOfWeek = now.add(Duration(days: 7 - now.weekday));

            for (RiwayatModel riwayat in listRiwayat) {
              DateTime tanggalPresensi =
                  DateTime.fromMillisecondsSinceEpoch(
                  int.parse(riwayat.tanggalPresensi));

              if (tanggalPresensi.isAfter(startOfWeek) &&
                  tanggalPresensi.isBefore(endOfWeek)) {
                resultRiwayat.add(riwayat); 
              }
            }

            resultRiwayat
                .sort((a, b) => b.tanggalPresensi.compareTo(a.tanggalPresensi));
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: resultRiwayat.length,
              itemBuilder: (context, index) {
                DateTime parsedDateTime = DateTime.fromMillisecondsSinceEpoch(
                    int.parse(resultRiwayat[index].tanggalPresensi));
                String formatDate =
                    DateFormat("dd MMMM yyyy", "ID").format(parsedDateTime);

                List<String> keteranganMasuk =
                    resultRiwayat[index].keteranganMasuk.split(" ");
                String keteranganMasukCapitalize = "";

                for (String kataSekarang in keteranganMasuk) {
                  keteranganMasukCapitalize +=
                      "${kataSekarang[0].toUpperCase()}${kataSekarang.substring(1).toLowerCase()} ";
                }

                List<String> keteranganKeluar =
                    resultRiwayat[index].ketaranganKeluar.split(" ");
                String keteranganKeluarCapitalize = "";

                for (String kataSekarangDua in keteranganKeluar) {
                  keteranganKeluarCapitalize +=
                      "${kataSekarangDua[0].toUpperCase()}${kataSekarangDua.substring(1).toLowerCase()} ";
                }
                return SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatDate,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      resultRiwayat[index].keteranganMasuk != 'Tidak Masuk'
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.only(
                                  top: 11, bottom: 17, left: 20, right: 13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFF5F5F5),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Masuk',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                          color: Color(0xFF00AC47),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: keteranganMasukCapitalize,
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 10,
                                                    color:
                                                        keteranganMasukCapitalize ==
                                                                'Telat '
                                                            ? const Color(
                                                                0xFFFFBA00)
                                                            : const Color(
                                                                0xFF00AC47))),
                                            TextSpan(
                                                text:
                                                    ' ${resultRiwayat[index].jamMasuk} WIB',
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10,
                                                    color:
                                                        keteranganMasukCapitalize ==
                                                                'Telat '
                                                            ? const Color(
                                                                0xFFFFBA00)
                                                            : const Color(
                                                                0xFF00AC47))),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/log in.svg',
                                        width: 35,
                                        height: 35,
                                      ),
                                      const SizedBox(
                                        width: 22,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 80),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'PT MARSTECH GLOBAL',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                resultRiwayat[index].alamat,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 9,
                                                  color: Color(0xFF878787),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.symmetric(vertical: 35),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFF5F5F5),
                              ),
                              child: Center(
                                  child: Text(
                                resultRiwayat[index].keteranganMasuk,
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              )),
                            ),
                      resultRiwayat[index].keteranganMasuk != 'Tidak Masuk'
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.only(
                                  top: 11, bottom: 17, left: 20, right: 13),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFF5F5F5),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Keluar',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 10,
                                          color: Color(0xFFEA4435),
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children:
                                              keteranganKeluarCapitalize == '- '
                                                  ? <TextSpan>[
                                                      const TextSpan(
                                                          text: 'BELUM KELUAR',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xFFEA4435))),
                                                    ]
                                                  : <TextSpan>[
                                                      TextSpan(
                                                          text:
                                                              keteranganKeluarCapitalize,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xFFEA4435))),
                                                      TextSpan(
                                                          text:
                                                              ' ${resultRiwayat[index].jamPulang} WIB',
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xFFEA4435))),
                                                    ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/log out.svg',
                                        width: 35,
                                        height: 35,
                                      ),
                                      const SizedBox(
                                        width: 22,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 80),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'PT MARSTECH GLOBAL',
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                resultRiwayat[index].alamat,
                                                style: const TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontSize: 9,
                                                  color: Color(0xFF878787),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              },
            );
          } else {
            return notFound();
          }
        },
      ),
    );
  }
}
