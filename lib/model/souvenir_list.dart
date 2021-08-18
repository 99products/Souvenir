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
  String imageUrlThumbnail;
  List<ItemsData> items;
  ProfileData dataProfile;

  RegionsData({
    this.id,
    this.title,
    this.description,
    this.shortDescription,
    this.imageUrlThumbnail,
    this.items,
    this.dataProfile,
  });

  factory RegionsData.fromJson(Map<String, dynamic> json) => RegionsData(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    shortDescription: json["shortDescription"],
    imageUrlThumbnail: json["imageUrlThumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "id": id,
    "description": description,
    "imageUrlThumbnail": imageUrlThumbnail,
  };
}
class ItemsData {
  String id;
  String title;
  String shortDescription;
  String latitude;
  String longitude;
  String imageUrlThumbnail;
  String imageUrlCapture;
  int distanceFromUserLocation;

  ItemsData({
    this.id,
    this.title,
    this.shortDescription,
    this.latitude,
    this.longitude,
    this.imageUrlThumbnail,
    this.imageUrlCapture,
    this.distanceFromUserLocation,
  });

  factory ItemsData.fromJson(Map<String, dynamic> json) => ItemsData(
    title: json["title"],
    id: json["id"],
    shortDescription: json["shortDescription"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    imageUrlThumbnail: json["imageUrlThumbnail"],
      imageUrlCapture: json["imageUrlCapture"]
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "id": id,
    "shortDescription": shortDescription,
    "latitude": latitude,
    "longitude":longitude,
    "imageUrlThumbnail": imageUrlThumbnail,
    "imageUrlCapture":imageUrlCapture,
  };
}

class ProfileData {
  String name;
  String userLocation;

  ProfileData({
    this.name,
    this.userLocation,
  });
}
