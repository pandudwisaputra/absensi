// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/exception_handler.dart';
import '../pages/connection.dart';

class RiwayatModel {
  int idUser;
  int idPresensi;
  String tanggalPresensi;
  String jamMasuk;
  String jamPulang;
  String tanggalPulang;
  String keteranganMasuk;
  String ketaranganKeluar;
  String latitude;
  String longitude;
  String alamat;
  String status;
  String keteranganTidakMasuk;
  String linkBukti;

  RiwayatModel({
    required this.idPresensi,
    required this.idUser,
    required this.tanggalPresensi,
    required this.jamMasuk,
    required this.jamPulang,
    required this.tanggalPulang,
    required this.keteranganMasuk,
    required this.ketaranganKeluar,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.status,
    required this.keteranganTidakMasuk,
    required this.linkBukti,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> json) {
    return RiwayatModel(
      idPresensi: json['id_presensi'],
      idUser: json['id_user'],
      tanggalPresensi: json['tanggal_presensi'],
      jamMasuk: json['jam_masuk'],
      jamPulang: json['jam_pulang'],
      tanggalPulang: json['tanggal_pulang'],
      keteranganMasuk: json['keterangan_masuk'],
      ketaranganKeluar: json['keterangan_keluar'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      alamat: json['alamat'],
      status: json['status'],
      keteranganTidakMasuk: json['keterangan_tidak_masuk'],
      linkBukti: json['link_bukti'],
    );
  }
}

class RiwayatRepository {
  static Future getData(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('idPegawai');
    try {
      var response = await http
          .get(Uri.parse('http://url/api/riwayatpresensi/$id'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body)["data"];
        List<RiwayatModel> listRiwayat =
            it.map((e) => RiwayatModel.fromJson(e)).toList();
        return listRiwayat;
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
}
