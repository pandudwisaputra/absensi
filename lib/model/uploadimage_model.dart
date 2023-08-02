// To parse this JSON data, do
//
//     final uploadImageModel = uploadImageModelFromJson(jsonString);

import 'dart:convert';

UploadImageModel uploadImageModelFromJson(String str) => UploadImageModel.fromJson(json.decode(str));

String uploadImageModelToJson(UploadImageModel data) => json.encode(data.toJson());

class UploadImageModel {
    String status;
    String message;
    String fileName;

    UploadImageModel({
        required this.status,
        required this.message,
        required this.fileName,
    });

    factory UploadImageModel.fromJson(Map<String, dynamic> json) => UploadImageModel(
        status: json["status"],
        message: json["message"],
        fileName: json["file_name"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "file_name": fileName,
    };
}
