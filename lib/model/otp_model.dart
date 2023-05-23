import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
    OtpModel({
        required this.code,
        required this.status,
        required this.data,
    });

    int code;
    String status;
    Data data;

    factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
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


OtpSalahModel otpSalahModelFromJson(String str) => OtpSalahModel.fromJson(json.decode(str));

String otpSalahModelToJson(OtpSalahModel data) => json.encode(data.toJson());

class OtpSalahModel {
    OtpSalahModel({
        required this.code,
        required this.status,
        required this.data,
    });

    int code;
    String status;
    String data;

    factory OtpSalahModel.fromJson(Map<String, dynamic> json) => OtpSalahModel(
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
