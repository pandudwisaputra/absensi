// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/exception_handler.dart';
import '../pages/connection.dart';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.code,
    required this.status,
    required this.data,
  });

  int code;
  String status;
  Data data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
    required this.idKaryawan,
    required this.email,
    required this.nama,
    required this.noHp,
    required this.avatar,
  });

  int idUser;
  String idKaryawan;
  String email;
  String nama;
  String noHp;
  String avatar;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json["id_user"],
        idKaryawan: json["id_karyawan"],
        email: json["email"],
        nama: json["nama"],
        noHp: json["no_hp"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "id_karyawan": idKaryawan,
        "email": email,
        "nama": nama,
        "no_hp": noHp,
        "avatar": avatar,
      };
}

class ProfileRepository {
  static Future<ProfileModel?> getProfile(BuildContext context) async {
    ProfileModel? profil;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt('idPegawai');
      var response = await http
          .get(Uri.parse('http://api.myfin.id:4000/api/profile/$id'), headers: {
        'X-API-Key': "12345678",
        'Accept': "application/json",
      });
      print(response.body);
      if (response.statusCode == 200) {
        ProfileModel decode = ProfileModel.fromJson(jsonDecode(response.body));
        profil = decode;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', decode.data.email);
        await prefs.setString('idKaryawan', decode.data.idKaryawan);
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
    return profil;
  }
}
