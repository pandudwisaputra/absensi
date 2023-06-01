// To parse this JSON data, do
//
//     final presensiModel = presensiModelFromJson(jsonString);

import 'dart:convert';

PresensiModel presensiModelFromJson(String str) =>
    PresensiModel.fromJson(json.decode(str));

String presensiModelToJson(PresensiModel data) => json.encode(data.toJson());

class PresensiModel {
  int code;
  String status;
  Data data;

  PresensiModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory PresensiModel.fromJson(Map<String, dynamic> json) => PresensiModel(
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
  String keterangan;

  Data({
    required this.idPresensi,
    required this.keterangan,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idPresensi: json["id_presensi"],
        keterangan: json["keterangan"],
      );

  Map<String, dynamic> toJson() => {
        "id_presensi": idPresensi,
        "keterangan": keterangan,
      };
}
