// To parse this JSON data, do
//
//     final checkStatusKaryawanModel = checkStatusKaryawanModelFromJson(jsonString);

import 'dart:convert';

CheckStatusKaryawanModel checkStatusKaryawanModelFromJson(String str) => CheckStatusKaryawanModel.fromJson(json.decode(str));

String checkStatusKaryawanModelToJson(CheckStatusKaryawanModel data) => json.encode(data.toJson());

class CheckStatusKaryawanModel {
    int code;
    String status;
    Data data;

    CheckStatusKaryawanModel({
        required this.code,
        required this.status,
        required this.data,
    });

    factory CheckStatusKaryawanModel.fromJson(Map<String, dynamic> json) => CheckStatusKaryawanModel(
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
    String statusKaryawan;

    Data({
        required this.statusKaryawan,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        statusKaryawan: json["status_karyawan"],
    );

    Map<String, dynamic> toJson() => {
        "status_karyawan": statusKaryawan,
    };
}
