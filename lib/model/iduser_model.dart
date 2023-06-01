import 'dart:convert';

IdUserModel idUserModelFromJson(String str) => IdUserModel.fromJson(json.decode(str));

String idUserModelToJson(IdUserModel data) => json.encode(data.toJson());

class IdUserModel {
    IdUserModel({
        required this.code,
        required this.status,
        required this.data,
    });

    int code;
    String status;
    Data data;

    factory IdUserModel.fromJson(Map<String, dynamic> json) => IdUserModel(
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
    });

    int idUser;
    String email;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        idUser: json["id_user"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "email": email,
    };
}
