import 'dart:convert';

List<RegionsData> regionFromJson(String str) =>
    List<RegionsData>.from(json.decode(str).map((x) => RegionsData.fromJson(x)));

String regionToJson(List<RegionsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<ItemsData> itemFromJson(String str) =>
    List<ItemsData>.from(json.decode(str).map((x) => ItemsData.fromJson(x)));

String itemToJson(List<ItemsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegionsData {
  String id;
  String title;
  String description;
  String shortDescription;
  int itemsCount;
  var geoLocation;
  double distance;

  RegionsData({
    this.id,
    this.title,
    this.description,
    this.shortDescription,
    this.itemsCount,
    this.geoLocation,
    this.distance,
  });

  factory RegionsData.fromJson(Map<String, dynamic> json) => RegionsData(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    shortDescription: json["shortDescription"],
    itemsCount: json["itemsCount"],
    geoLocation: json["geoLocation"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "id": id,
    "description": description,
    "itemsCount": itemsCount,
    "geoLocation": geoLocation,
    "distance": distance,
  };
}
class ItemsData {
  String id;
  String title;
  String shortDescription;
  var geoLocation;
  double distance;

  ItemsData({
    this.id,
    this.title,
    this.shortDescription,
    this.geoLocation,
    this.distance,
  });

  factory ItemsData.fromJson(Map<String, dynamic> json) => ItemsData(
    title: json["title"],
    id: json["id"],
    shortDescription: json["shortDescription"],
    geoLocation: json["geoLocation"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "id": id,
    "shortDescription": shortDescription,
    "geoLocation": geoLocation,
    "distance": distance,
  };
}
