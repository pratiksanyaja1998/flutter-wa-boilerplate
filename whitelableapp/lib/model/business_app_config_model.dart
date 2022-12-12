
import 'dart:convert';

BusinessAppConfigModel businessAppConfigModelFromJson(String str) => BusinessAppConfigModel.fromJson(json.decode(str));

String businessAppConfigModelToJson(BusinessAppConfigModel data) => json.encode(data.toJson());

class BusinessAppConfigModel {
  BusinessAppConfigModel({
    required this.businessId,
    required this.type,
    required this.slug,
    required this.domain,
    required this.businessName,
    required this.businessLocation,
    required this.businessDescription,
    required this.logo,
    required this.version,
    required this.authenticationType,
    required this.appName,
    required this.theme,
    required this.order,
    required this.delivery,
    required this.invoice,
    required this.contactUs,
    required this.product,
    required this.activeTime,
    required this.androidPackageName,
    required this.iosBundleIdentifier,
    required this.enableAppCoin,
    required this.appHomePage,
    required this.activeTheme,
    required this.socialLink,
    required this.googleAndroidFile,
    required this.googleIosFile,
    required this.subscription,
    required this.restaurant,
    required this.env,
    required this.fcmServerKey,
    required this.paymentKey,
    required this.paymentType,
  });

  int businessId;
  String type;
  String slug;
  String domain;
  String businessName;
  BusinessLocation businessLocation;
  String businessDescription;
  String logo;
  String version;
  String authenticationType;
  String appName;
  BusinessTheme theme;
  BusinessOrder order;
  BusinessDelivery delivery;
  Map<dynamic, dynamic> invoice;
  BusinessContactUs contactUs;
  BusinessProduct product;
  Map<dynamic, dynamic> activeTime;
  String androidPackageName;
  String iosBundleIdentifier;
  bool enableAppCoin;
  Map<dynamic, dynamic> appHomePage;
  int activeTheme;
  Map<dynamic, dynamic> socialLink;
  String googleAndroidFile;
  String googleIosFile;
  Map<dynamic, dynamic> subscription;
  Map<dynamic, dynamic> restaurant;
  String env;
  String fcmServerKey;
  String paymentKey;
  String paymentType;

  factory BusinessAppConfigModel.fromJson(Map<String, dynamic> json) => BusinessAppConfigModel(
    businessId: json["businessId"] ?? 0,
    type: json["type"] ?? "",
    slug: json["slug"] ?? "",
    domain: json["domain"] ?? "",
    businessName: json["businessName"] ?? "",
    businessLocation: BusinessLocation.fromJson(json["businessLocation"] ?? {}),
    businessDescription: json["businessDescription"] ?? "",
    logo: json["logo"] ?? "",
    version: json["version"] ?? "",
    authenticationType: json["authentication_type"] ?? "",
    appName: json["appName"] ?? "",
    theme: BusinessTheme.fromJson(json["theme"] ?? {}),
    order: BusinessOrder.fromJson(json["order"] ?? {}),
    delivery: BusinessDelivery.fromJson(json["delivery"] ?? {}),
    invoice: json["invoice"] ?? {},
    contactUs: BusinessContactUs.fromJson(json["contactUs"] ?? {}),
    product: BusinessProduct.fromJson(json["product"] ?? {}),
    activeTime: json["activeTime"] ?? {},
    androidPackageName: json["androidPackageName"] ?? "",
    iosBundleIdentifier: json["iosBundleIdentifier"] ?? "",
    enableAppCoin: json["enableAppCoin"] ?? false,
    appHomePage: json["appHomePage"] ?? {},
    activeTheme: json["activeTheme"] ?? 0,
    socialLink: json["social_link"] ?? {},
    googleAndroidFile: json["google_android_file"] ?? "",
    googleIosFile: json["google_ios_file"] ?? "",
    subscription: json["subscription"] ?? {},
    restaurant: json["restaurant"] ?? {},
    env: json["ENV"] ?? "",
    fcmServerKey: json["fcm_server_key"] ?? "",
    paymentKey: json["paymentKey"] ?? "",
    paymentType: json["paymentType"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "businessId": businessId,
    "type": type,
    "slug": slug,
    "domain": domain,
    "businessName": businessName,
    "businessLocation": businessLocation.toJson(),
    "businessDescription": businessDescription,
    "logo": logo,
    "version": version,
    "authentication_type": authenticationType,
    "appName": appName,
    "theme": theme.toJson(),
    "order": order.toJson(),
    "delivery": delivery.toJson(),
    "invoice": invoice,
    "contactUs": contactUs.toJson(),
    "product": product.toJson(),
    "activeTime": activeTime,
    "androidPackageName": androidPackageName,
    "iosBundleIdentifier": iosBundleIdentifier,
    "enableAppCoin": enableAppCoin,
    "appHomePage": appHomePage,
    "activeTheme": activeTheme,
    "social_link": socialLink,
    "google_android_file": googleAndroidFile,
    "google_ios_file": googleIosFile,
    "subscription": subscription,
    "restaurant": restaurant,
    "ENV": env,
    "fcm_server_key": fcmServerKey,
    "paymentKey": paymentKey,
    "paymentType": paymentType,
  };
}

class BusinessLocation {
  BusinessLocation({
    required this.street,
    required this.area,
    required this.city,
    required this.country,
    required this.pincode,
  });

  String street;
  String area;
  String city;
  String country;
  String pincode;

  factory BusinessLocation.fromJson(Map<String, dynamic> json) => BusinessLocation(
    street: json["street"] ?? "",
    area: json["area"] ?? "",
    city: json["city"] ?? "",
    country: json["country"] ?? "",
    pincode: json["pincode"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "area": area,
    "city": city,
    "country": country,
    "pincode": pincode,
  };
}

class BusinessTheme {
  BusinessTheme({
    required this.dark,
    required this.showTabBar,
    required this.themeColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isLoginRequired,
    required this.screenBackground,
  });

  bool dark;
  bool showTabBar;
  String themeColor;
  String primaryColor;
  String secondaryColor;
  bool isLoginRequired;
  String screenBackground;

  factory BusinessTheme.fromJson(Map<String, dynamic> json) => BusinessTheme(
    dark: json["dark"] ?? false,
    showTabBar: json["showTabBar"] ?? false,
    themeColor: json["themeColor"] ?? "",
    primaryColor: json["primaryColor"] ?? "",
    secondaryColor: json["secondaryColor"] ?? "",
    isLoginRequired: json["isLoginRequired"] ?? false,
    screenBackground: json["screenBackground"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "dark": dark,
    "showTabBar": showTabBar,
    "themeColor": themeColor,
    "primaryColor": primaryColor,
    "secondaryColor": secondaryColor,
    "isLoginRequired": isLoginRequired,
    "screenBackground": screenBackground,
  };
}

class BusinessOrder {
  BusinessOrder({
    required this.pickup,
    required this.delivery,
    required this.autoAccept,
    required this.cancelFromUser,
    required this.cashOnDelivery,
    required this.orderDeliveryCharge,
    required this.orderPreparationTime,
    required this.orderDeliveryChargeType,
    required this.orderDeliveryChargeOnMinAmount,
  });

  bool pickup;
  bool delivery;
  bool autoAccept;
  bool cancelFromUser;
  List<dynamic> cashOnDelivery;
  dynamic orderDeliveryCharge;
  int orderPreparationTime;
  String orderDeliveryChargeType;
  String orderDeliveryChargeOnMinAmount;

  factory BusinessOrder.fromJson(Map<String, dynamic> json) => BusinessOrder(
    pickup: json["pickup"] ?? false,
    delivery: json["delivery"] ?? false,
    autoAccept: json["autoAccept"] ?? false,
    cancelFromUser: json["cancelFromUser"] ?? false,
    cashOnDelivery: json["cashOnDelivery"] ?? [],
    orderDeliveryCharge: json["orderDeliveryCharge"] ?? 0.0,
    orderPreparationTime: json["orderPreparartionTime"] ?? 0,
    orderDeliveryChargeType: json["orderDeliveryChargeType"] ?? "",
    orderDeliveryChargeOnMinAmount: json["orderDeliveryChargeOnMinAmount"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "pickup": pickup,
    "delivery": delivery,
    "autoAccept": autoAccept,
    "cancelFromUser": cancelFromUser,
    "cashOnDelivery": cashOnDelivery,
    "orderDeliveryCharge": orderDeliveryCharge,
    "orderPreparartionTime": orderPreparationTime,
    "orderDeliveryChargeType": orderDeliveryChargeType,
    "orderDeliveryChargeOnMinAmount": orderDeliveryChargeOnMinAmount
  };
}

class BusinessDelivery {
  BusinessDelivery({
    required this.pickUp,
    required this.delivery,
    required this.autoAccept,
    required this.cancelFromUser,
    required this.cashOnDelivery,
    required this.availableLocation,
    required this.orderPreparationTime,
  });

  bool pickUp;
  bool delivery;
  bool autoAccept;
  bool cancelFromUser;
  List<dynamic> cashOnDelivery;
  AvailableLocation availableLocation;
  int orderPreparationTime;

  factory BusinessDelivery.fromJson(Map<String, dynamic> json) => BusinessDelivery(
    pickUp: json["pickup"] ?? false,
    delivery: json["delivery"] ?? false,
    autoAccept: json["autoAccept"] ?? false,
    cancelFromUser: json["cancelFromUser"] ?? false,
    cashOnDelivery: json["cashOnDelivery"] ?? [],
    availableLocation: AvailableLocation.fromJson(json["availableLocation"] ?? {
      "city": [],
      "state": [],
      "country": [],
      "pincode": [],
    }),
    orderPreparationTime: json["orderPreparartionTime"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "pickup": pickUp,
    "delivery": delivery,
    "autoAccept": autoAccept,
    "cancelFromUser": cancelFromUser,
    "cashOnDelivery": cashOnDelivery,
    "availableLocation": availableLocation,
    "orderPreparartionTime": orderPreparationTime,
  };
}

class AvailableLocation {
  AvailableLocation({
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode,
  });

  List<dynamic> city;
  List<dynamic> state;
  List<dynamic> country;
  List<dynamic> pinCode;

  factory AvailableLocation.fromJson(Map<String, dynamic> json) => AvailableLocation(
    city: json["city"] ?? [],
    state: json["state"] ?? [],
    country: json["country"] ?? [],
    pinCode: json["pincode"] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "state": state,
    "country": country,
    "pincode": pinCode
  };
}

class BusinessContactUs {
  BusinessContactUs({
    required this.email,
    required this.mobile,
    required this.address,
    required this.bussinessName,
  });

  String email;
  String mobile;
  String address;
  String bussinessName;

  factory BusinessContactUs.fromJson(Map<String, dynamic> json) => BusinessContactUs(
    email: json["email"] ?? "",
    mobile: json["mobile"] ?? "",
    address: json["address"] ?? "",
    bussinessName: json["bussinessName"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "mobile": mobile,
    "address": address,
    "bussinessName": bussinessName,
  };
}

class BusinessProduct {
  BusinessProduct({
    required this.hidePrice,
    required this.showReview,
    required this.aspectRatio,
    required this.showCategory,
    required this.showVariants,
    required this.showSubCategory,
    required this.availableForSubscription,
  });

  bool hidePrice;
  bool showReview;
  List<dynamic> aspectRatio;
  bool showCategory;
  bool showVariants;
  bool showSubCategory;
  bool availableForSubscription;

  factory BusinessProduct.fromJson(Map<String, dynamic> json) => BusinessProduct(
    hidePrice: json["hidePrice"] ?? false,
    showReview: json["showReview"] ?? false,
    aspectRatio: json["aspectRatio"] ?? [],
    showCategory: json["showCategory"] ?? false,
    showVariants: json["showVariants"] ?? false,
    showSubCategory: json["showSubCategory"] ?? false,
    availableForSubscription: json["availableForSubscription"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "hidePrice": hidePrice,
    "showReview": showReview,
    "aspectRatio": aspectRatio,
    "showCategory": showCategory,
    "showVariants": showVariants,
    "showSubCategory": showSubCategory,
    "availableForSubscription": availableForSubscription,
  };
}




