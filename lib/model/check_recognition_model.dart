// To parse this JSON data, do
//
//     final checkRecognitionModel = checkRecognitionModelFromJson(jsonString);

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:absensi/helper/exception_handler.dart';
import 'package:absensi/pages/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

CheckRecognitionModel checkRecognitionModelFromJson(String str) =>
    CheckRecognitionModel.fromJson(json.decode(str));

String checkRecognitionModelToJson(CheckRecognitionModel data) =>
    json.encode(data.toJson());

class CheckRecognitionModel {
  int code;
  String status;
  Data data;

  CheckRecognitionModel({
    required this.code,
    required this.status,
    required this.data,
  });

  factory CheckRecognitionModel.fromJson(Map<String, dynamic> json) =>
      CheckRecognitionModel(
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
  int idRecognition;
  int idUser;
  String key;
  String name;
  String locationLeft;
  String locationTop;
  String locationRight;
  String locationBottom;
  String embeddings;
  String distance;

  Data({
    required this.idRecognition,
    required this.idUser,
    required this.key,
    required this.name,
    required this.locationLeft,
    required this.locationTop,
    required this.locationRight,
    required this.locationBottom,
    required this.embeddings,
    required this.distance,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idRecognition: json["id_recognition"],
        idUser: json["id_user"],
        key: json["key"],
        name: json["name"],
        locationLeft: json["location_left"],
        locationTop: json["location_top"],
        locationRight: json["location_right"],
        locationBottom: json["location_bottom"],
        embeddings: json["embeddings"],
        distance: json["distance"],
      );

  Map<String, dynamic> toJson() => {
        "id_recognition": idRecognition,
        "id_user": idUser,
        "key": key,
        "name": name,
        "location_left": locationLeft,
        "location_top": locationTop,
        "location_right": locationRight,
        "location_bottom": locationBottom,
        "embeddings": embeddings,
        "distance": distance,
      };
}

class RecognitionRepository {
  static Future<bool?> getRecognition(BuildContext context) async {
    bool? isAvailable;
    try {
      SharedPreferences server = await SharedPreferences.getInstance();

      int? idPegawai = server.getInt('idPegawai');
      var response = await http.get(
          Uri.parse('http://api.myfin.id:4000/api/recognition/$idPegawai'),
          headers: {
            'X-API-Key': "12345678",
            'Accept': "application/json",
          });
      if (response.statusCode == 200) {
        isAvailable = true;
      } else {
        isAvailable = false;
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
    return isAvailable;
  }
}
