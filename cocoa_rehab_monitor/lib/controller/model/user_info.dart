// To parse this JSON data, do
//
//     final userInfo = userInfoFromJson(jsonString);

import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    this.id,
    this.token,
    this.name,
    this.phone,
    this.image,
    this.email,
    this.country,
    this.sex,
    this.loginId,
    this.loginUname,
    this.loginRole,
    this.loginLastLogin,
    this.loginStatus,
    this.loginNotificationToken,
  });

  String? id;
  String? token;
  String? name;
  String? phone;
  String? image;
  String? email;
  String? country;
  String? sex;
  String? loginId;
  String? loginUname;
  String? loginRole;
  String? loginLastLogin;
  String? loginStatus;
  String? loginNotificationToken;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    id: json["id"],
    token: json["token"],
    name: json["name"],
    phone: json["phone"],
    image: json["image"],
    email: json["email"],
    country: json["country"],
    sex: json["sex"],
    loginId: json["Login.id"],
    loginUname: json["Login.uname"],
    loginRole: json["Login.role"],
    loginLastLogin: json["Login.last_login"],
    loginStatus: json["Login.status"],
    loginNotificationToken: json["Login.notification_token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "name": name,
    "phone": phone,
    "image": image,
    "email": email,
    "country": country,
    "sex": sex,
    "Login.id": loginId,
    "Login.uname": loginUname,
    "Login.role": loginRole,
    "Login.last_login": loginLastLogin,
    "Login.status": loginStatus,
    "Login.notification_token": loginNotificationToken,
  };
}
