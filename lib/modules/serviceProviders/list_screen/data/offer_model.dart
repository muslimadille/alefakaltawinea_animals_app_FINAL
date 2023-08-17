class OfferModel {
  dynamic id;
  String? userId;
  String? price;
  String? discountValue;
  String? expirationDate;
  String? title;
  String? titleEn;
  String? code;
  String? usageTimes;
  List<Features>? features;
  String? createdAt;
  String? updatedAt;
  String?photo;
  String?url;
  String?photoEn;

  OfferModel(
      {this.id,
        this.userId,
        this.price,
        this.discountValue,
        this.expirationDate,
        this.title,
        this.titleEn,
        this.code,
        this.usageTimes,
        this.features,
        this.createdAt,
        this.updatedAt,
      this.photo,
        this.photoEn,
      this.url});

  OfferModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    price = json['price'];
    discountValue = json['discount_value'];
    expirationDate = json['expiration_date'];
    title = json['title'];
    titleEn = json['title_en'];
    code = json['code'];
    usageTimes = json['usage_times'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    photo=json["photo"];
    url=json["url"];
    photoEn=json["photo_en"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['price'] = this.price;
    data['discount_value'] = this.discountValue;
    data['expiration_date'] = this.expirationDate;
    data['title'] = this.title;
    data['title_en'] = this.titleEn;
    data['code'] = this.code;
    data['usage_times'] = this.usageTimes;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['photo']=this.photo;
    data["url"]=this.url;
    return data;
  }
}

class Features {
  String? ar;
  String? en;

  Features({this.ar, this.en});

  Features.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}