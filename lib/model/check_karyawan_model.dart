// To parse this JSON data, do
//
//     final checkKaryawanModel = checkKaryawanModelFromJson(jsonString);

// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/pages/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

CheckKaryawanModel checkKaryawanModelFromJson(String str) =>
    CheckKaryawanModel.fromJson(json.decode(str));

String checkKaryawanModelToJson(CheckKaryawanModel data) =>
    json.encode(data.toJson());

class CheckKaryawanModel {
  CheckKaryawanModel({
    required this.code,
    required this.status,
    required this.data,
  });

  int code;
  String status;
  Data data;

  factory CheckKaryawanModel.fromJson(Map<String, dynamic> json) =>
      CheckKaryawanModel(
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
  Data({
    required this.idKaryawan,
    required this.idJabatan,
    required this.namaLengkap,
    required this.foto,
    required this.alamat,
    required this.agama,
    required this.email,
    required this.noHp,
    required this.pendidikan,
    required this.jabatan,
  });

  String idKaryawan;
  int idJabatan;
  String namaLengkap;
  String foto;
  String alamat;
  String agama;
  String email;
  String noHp;
  String pendidikan;
  String jabatan;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idKaryawan: json["id_karyawan"],
        idJabatan: json["id_jabatan"],
        namaLengkap: json["nama_lengkap"],
        foto: json["foto"],
        alamat: json["alamat"],
        agama: json["agama"],
        email: json["email"],
        noHp: json["no_hp"],
        pendidikan: json["pendidikan"],
        jabatan: json["jabatan"],
      );

  Map<String, dynamic> toJson() => {
        "id_karyawan": idKaryawan,
        "id_jabatan": idJabatan,
        "nama_lengkap": namaLengkap,
        "foto": foto,
        "alamat": alamat,
        "agama": agama,
        "email": email,
        "no_hp": noHp,
        "pendidikan": pendidikan,
        "jabatan": jabatan,
      };
}

class KaryawanRepository {
  static Future<CheckKaryawanModel?> getKaryawan(BuildContext context) async {
    CheckKaryawanModel? profil;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? baseUrl = prefs.getString('server');
      String? email = prefs.getString('email');
      String? idKaryawan = prefs.getString('idKaryawan');
      var response =
          await http.get(Uri.parse('$baseUrl/karyawancheck/$email/$idKaryawan'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      print(response.body);
      if (response.statusCode == 200) {
        CheckKaryawanModel decode = CheckKaryawanModel.fromJson(jsonDecode(response.body));
        profil = decode;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', decode.data.email);
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
    return profil;
  }
}