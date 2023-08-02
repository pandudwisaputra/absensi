// To parse this JSON data, do
//
//     final presensiCheckModel = presensiCheckModelFromJson(jsonString);

// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/pages/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

PresensiCheckModel presensiCheckModelFromJson(String str) =>
    PresensiCheckModel.fromJson(json.decode(str));

String presensiCheckModelToJson(PresensiCheckModel data) =>
    json.encode(data.toJson());

class PresensiCheckModel {
  int code;
  String status;
  Data data;

  PresensiCheckModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory PresensiCheckModel.fromJson(Map<String, dynamic> json) =>
      PresensiCheckModel(
        code: json["code"],
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int idPresensi;
  int idUser;
  String tanggalPresensi;
  String jamMasuk;
  String jamPulang;
  String tanggalPulang;
  String keteranganMasuk;
  String keteranganKeluar;
  String latitude;
  String longitude;
  String alamat;
  String status;

  Data({
    required this.idPresensi,
    required this.idUser,
    required this.tanggalPresensi,
    required this.jamMasuk,
    required this.jamPulang,
    required this.tanggalPulang,
    required this.keteranganMasuk,
    required this.keteranganKeluar,
    required this.latitude,
    required this.longitude,
    required this.alamat,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idPresensi: json["id_presensi"],
        idUser: json["id_user"],
        tanggalPresensi: json["tanggal_presensi"],
        jamMasuk: json["jam_masuk"],
        jamPulang: json["jam_pulang"],
        tanggalPulang: json["tanggal_pulang"],
        keteranganMasuk: json["keterangan_masuk"],
        keteranganKeluar: json["keterangan_keluar"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        alamat: json["alamat"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id_presensi": idPresensi,
        "id_user": idUser,
        "tanggal_presensi": tanggalPresensi,
        "jam_masuk": jamMasuk,
        "jam_pulang": jamPulang,
        "tanggal_pulang": tanggalPulang,
        "keterangan_masuk": keteranganMasuk,
        "keterangan_keluar": keteranganKeluar,
        "latitude": latitude,
        "longitude": longitude,
        "alamat": alamat,
        "status": status,
      };
}

class PresensiCheckRepository {
  static Future<PresensiCheckModel?> getPresensiCheck(
      BuildContext context) async {
    PresensiCheckModel? presensiCheck;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt('idPegawai');
      var response = await http.get(
          Uri.parse('http://api2.myfin.id:4500/api/presensicheck/$id'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          });
      if (response.statusCode == 200) {
        PresensiCheckModel decode =
            PresensiCheckModel.fromJson(jsonDecode(response.body));
        presensiCheck = decode;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('tanggalPresensi', decode.data.tanggalPresensi);
        prefs.setInt('idPresensi', decode.data.idPresensi);
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
    return presensiCheck;
  }
}
