// To parse this JSON data, do
//
//     final smartphoneCheckModel = smartphoneCheckModelFromJson(jsonString);

import 'dart:convert';


SmartphoneCheckModel smartphoneCheckModelFromJson(String str) => SmartphoneCheckModel.fromJson(json.decode(str));

String smartphoneCheckModelToJson(SmartphoneCheckModel data) => json.encode(data.toJson());

class SmartphoneCheckModel {
    int code;
    String status;
    Data data;

    SmartphoneCheckModel({
        required this.code,
        required this.status,
        required this.data,
    });

    factory SmartphoneCheckModel.fromJson(Map<String, dynamic> json) => SmartphoneCheckModel(
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
    int idUser;
    String androidId;

    Data({
        required this.idUser,
        required this.androidId,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json["id_user"],
        androidId: json["android_id"],
    );

    Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "android_id": androidId,
    };
}