 class AccommodationModel {

  AccommodationModel({
    required this.id,
    required this.images,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.quantityPerDay,
    required this.business,
  });

  int id;
  List<Map<dynamic, dynamic>> images;
  String name;
  String description;
  String price;
  String type;
  int quantityPerDay;
  int business;

  factory AccommodationModel.fromJson(Map<String, dynamic> json) => AccommodationModel(
    id: json["id"],
    images: json["images"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    type: json["type"],
    quantityPerDay: json["qty_per_day"],
    business: json["business"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "images": images,
    "name": name,
    "description": description,
    "price": price,
    "type": type,
    "qty_per_day": quantityPerDay,
    "business": business,
  };

 }