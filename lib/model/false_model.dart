// To parse this JSON data, do
//
//     final falseModel = falseModelFromJson(jsonString);

import 'dart:convert';

FalseModel falseModelFromJson(String str) => FalseModel.fromJson(json.decode(str));

String falseModelToJson(FalseModel data) => json.encode(data.toJson());

class FalseModel {
    FalseModel({
        required this.code,
        required this.status,
        required this.data,
    });

    int code;
    String status;
    String data;

    factory FalseModel.fromJson(Map<String, dynamic> json) => FalseModel(
        code: json["code"],
        status: json["status"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": data,
    };
}
