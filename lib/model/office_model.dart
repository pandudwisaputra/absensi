// To parse this JSON data, do
//
//     final officeModel = officeModelFromJson(jsonString);

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/exception_handler.dart';
import '../pages/connection.dart';

OfficeModel officeModelFromJson(String str) =>
    OfficeModel.fromJson(json.decode(str));

String officeModelToJson(OfficeModel data) => json.encode(data.toJson());

class OfficeModel {
  OfficeModel({
    required this.code,
    required this.status,
    required this.data,
  });

  int code;
  String status;
  Data data;

  factory OfficeModel.fromJson(Map<String, dynamic> json) => OfficeModel(
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
    required this.namaKantor,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.jamMasuk,
    required this.jamPulang,
    required this.radius,
  });

  String namaKantor;
  String alamat;
  String latitude;
  String longitude;
  String jamMasuk;
  String jamPulang;
  String radius;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        namaKantor: json["nama_kantor"],
        alamat: json["alamat"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        jamMasuk: json["jam_masuk"],
        jamPulang: json["jam_pulang"],
        radius: json["radius"],
      );

  Map<String, dynamic> toJson() => {
        "nama_kantor": namaKantor,
        "alamat": alamat,
        "latitude": latitude,
        "longitude": longitude,
        "jam_masuk": jamMasuk,
        "jam_pulang": jamPulang,
        "radius": radius,
      };
}

class OfficeRepository {
  static Future<OfficeModel?> getOffice(BuildContext context) async {
    OfficeModel? office;
    try {
      var response = await http
          .get(Uri.parse('http://api2.myfin.id:4500/api/office/1'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      if (response.statusCode == 200) {
        OfficeModel decode = OfficeModel.fromJson(jsonDecode(response.body));
        office = decode;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setDouble('latitude', double.parse(decode.data.latitude));
        await prefs.setDouble('longitude', double.parse(decode.data.longitude));
        await prefs.setInt('radius', int.parse(decode.data.radius));
        await prefs.setString('namaKantor', decode.data.namaKantor);
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
    return office;
  }
}
