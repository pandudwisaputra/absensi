// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

RegisterModel postFromJson(String str) => RegisterModel.fromJson(json.decode(str));

String postToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
    RegisterModel({
        required this.code,
        required this.status,
        required this.data,
    });

    int code;
    String status;
    Data data;

    factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
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
