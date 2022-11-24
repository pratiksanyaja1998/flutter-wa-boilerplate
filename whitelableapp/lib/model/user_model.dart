
class UserModel {

  UserModel({
    required this.userName,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.type,
    required this.phone,
    required this.business,
    required this.photo,
    required this.franchise,
    required this.approved,
    required this.isTester,
    required this.coin,
    required this.telegramUserName,
    required this.referralCode,
    required this.referBy,
    required this.socialProfiles,
    required this.setting,
    required this.token,
    required this.id,
  });

  String userName;
  String email;
  String firstName;
  String lastName;
  bool isActive;
  String type;
  String phone;
  int business;
  String photo;
  int franchise;
  bool approved;
  bool isTester;
  String coin;
  String telegramUserName;
  String? referralCode;
  String? referBy;
  List<dynamic> socialProfiles;
  UserSetting setting;
  String token;
  int id;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userName: json["username"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    isActive: json["is_active"],
    type: json["type"],
    phone: json["phone"],
    business: json["business"],
    photo: json["photo"],
    franchise: json["franchise"],
    approved: json["approved"],
    isTester: json["is_tester"],
    coin: json["coin"],
    telegramUserName: json["telegram_username"],
    referralCode: json["referral_code"],
    referBy: json["refer_by"],
    socialProfiles: json["social_profiles"],
    setting: UserSetting.fromJson(json["setting"]),
    token: json["token"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "username": userName,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "is_active": isActive,
    "type": type,
    "phone": phone,
    "business": business,
    "photo": photo,
    "franchise": franchise,
    "approved": approved,
    "is_tester": isTester,
    "coin": coin,
    "telegram_username": telegramUserName,
    "referral_code": referralCode,
    "refer_by": referBy,
    "social_profiles": socialProfiles,
    "setting": setting.toJson(),
    "token": token,
    "id": id,
  };

}

class UserSetting {
  UserSetting({
    required this.user,
    required this.orderUpdateNotification,
    required this.promotionNotification,
    required this.id,
  });

  int user;
  bool orderUpdateNotification;
  bool promotionNotification;
  int id;

  factory UserSetting.fromJson(Map<String, dynamic> json) => UserSetting(
    user: json["user"],
    orderUpdateNotification: json["order_update_notification"],
    promotionNotification: json["promotion_notification"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user": user,
    "order_update_notification": orderUpdateNotification,
    "promotion_notification": promotionNotification,
    "id": id,
  };
}