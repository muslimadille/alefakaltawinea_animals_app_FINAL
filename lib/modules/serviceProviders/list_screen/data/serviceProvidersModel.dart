import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/offer_model.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/photo_model.dart';

class ServiceProviderModel {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  ServiceProviderModel(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? address;
  String? phone;
  String? email;
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
  String? website;
  int? is_fav;
  String?type_id;
  String?url;
  List<OfferModel>? offers;
  List<PhotoModel>? photos;
  String?contact_phone;





  Data(
      {this.id,
        this.name,
        this.address,
        this.phone,
        this.email,
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
        this.website,
        this.is_fav,
      this.offers,
        this.photos,
        this.type_id,
        this.url,
        this.contact_phone
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
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
    website = json['website'];
    is_fav=json['is_fav'];
    type_id=json['type_id'];
    url=json['url'];
    contact_phone=json['contact_phone']??"";
    if (json['offers'] != null) {
      offers = <OfferModel>[];
      json['offers'].forEach((v) {
        offers!.add(new OfferModel.fromJson(v));
      });
    }
    if (json['photos'] != null) {
      photos = <PhotoModel>[];
      json['photos'].forEach((v) {
        photos!.add(new PhotoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['banner_photo'] = this.bannerPhoto;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['region_id'] = this.regionId;
    data['region_name'] = this.regionName;
    data['state_id'] = this.stateId;
    data['state_name'] = this.stateName;
    data['is_online'] = this.isOnline;
    data['category_id'] = this.categoryId;
    data['website'] = this.website;
    data['is_fav'] = this.is_fav;
    data['type_id']=this.type_id;
    data['url']=this.url;
    data['contact_phone']=this.contact_phone;
    if (this.offers != null) {
      data['offers'] = this.offers!.map((v) => v.toJson()).toList();
    }
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}