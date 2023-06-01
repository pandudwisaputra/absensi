// To parse this JSON data, do
//
//     final verifModel = verifModelFromJson(jsonString);

import 'dart:convert';

VerifModel verifModelFromJson(String str) => VerifModel.fromJson(json.decode(str));

String verifModelToJson(VerifModel data) => json.encode(data.toJson());

class VerifModel {
    VerifModel({
        required this.code,
        required this.status,
        required this.data,
    });

    int code;
    String status;
    Data data;

    factory VerifModel.fromJson(Map<String, dynamic> json) => VerifModel(
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
        required this.email,
        required this.otp,
        required this.status,
    });

    String email;
    String otp;
    String status;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json["email"],
        otp: json["otp"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "status": status,
    };
}
