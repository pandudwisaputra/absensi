// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

AktivasiModel postFromJson(String str) =>
    AktivasiModel.fromJson(json.decode(str));

String postToJson(AktivasiModel data) => json.encode(data.toJson());

class AktivasiModel {
  AktivasiModel({
    required this.code,
    required this.status,
    required this.data,
  });

  int code;
  String status;
  Data data;

  factory AktivasiModel.fromJson(Map<String, dynamic> json) => AktivasiModel(
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
    required this.idUser,
    required this.email,
    required this.status,
  });

  int idUser;
  String email;
  String status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json["id_user"],
        email: json["email"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "email": email,
        "status": status,
      };
}
