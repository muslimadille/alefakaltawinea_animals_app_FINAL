import 'dart:convert';

import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/offer_model.dart';

import '../../serviceProviders/list_screen/data/photo_model.dart';
UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));
String userDataToJson(UserData data) => json.encode(data.toJson());
class UserData {
  UserData({
      this.id, 
      this.name, 
      this.address, 
      this.phone, 
      this.whatsapp, 
      this.email, 
      this.website, 
      this.photo, 
      this.bannerPhoto, 
      this.longitude, 
      this.latitude, 
      this.regionId, 
      this.regionName, 
      this.stateId, 
      this.stateName, 
      this.isOnline, 
      this.categoryId, 
      this.offers, 
      this.color, 
      this.userTypeId, 
      this.token, 
      this.activate,
    this.photos
  });

  UserData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    whatsapp = json['whatsapp'];
    email = json['email'];
    website = json['website'];
    photo = json['photo'];
    bannerPhoto = json['banner_photo'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    regionId = json['region_id'];
    regionName = json['region_name'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    isOnline = json['is_online'];
    categoryId = json['category_id'];
    if (json['offers'] != null) {
      offers = [];
      json['offers'].forEach((v) {
        offers?.add(OfferModel.fromJson(v));
      });
    }
    color = json['color'];
    userTypeId = json['user_type_id'];
    token = json['token'];
    activate = json['activate'];
    if (json['photos'] != null) {
      photos = <PhotoModel>[];
      json['photos'].forEach((v) {
        photos!.add(new PhotoModel.fromJson(v));
      });
    }
  }
  dynamic id;
  String? name;
  String? address;
  String? phone;
  String? whatsapp;
  String? email;
  String? website;
  String? photo;
  String? bannerPhoto;
  String? longitude;
  String? latitude;
  String? regionId;
  String? regionName;
  String? stateId;
  String? stateName;
  String? isOnline;
  String? categoryId;
  List<OfferModel>? offers;
  String? color;
  String? userTypeId;
  String? token;
  dynamic? activate;
  List<PhotoModel>? photos;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['address'] = address;
    map['phone'] = phone;
    map['whatsapp'] = whatsapp;
    map['email'] = email;
    map['website'] = website;
    map['photo'] = photo;
    map['banner_photo'] = bannerPhoto;
    map['longitude'] = longitude;
    map['latitude'] = latitude;
    map['region_id'] = regionId;
    map['region_name'] = regionName;
    map['state_id'] = stateId;
    map['state_name'] = stateName;
    map['is_online'] = isOnline;
    map['category_id'] = categoryId;
    if (offers != null) {
      map['offers'] = offers?.map((v) => v.toJson()).toList();
    }
    map['color'] = color;
    map['user_type_id'] = userTypeId;
    map['token'] = token;
    map['activate'] = activate;
    if (this.photos != null) {
      map['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}