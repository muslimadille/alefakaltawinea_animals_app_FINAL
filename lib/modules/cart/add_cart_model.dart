class AddCartModel {
  String? name;
  String? kind;
  String? family;
  String? gender;
  String? photo;
  String? country;


  AddCartModel(
      {this.name,
        this.kind,
        this.family,
        this.gender,
        this.photo,
        this.country,
       });

  AddCartModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    kind = json['kind'];
    family = json['family'];
    gender = json['gender'];
    photo = json['photo'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['kind'] = this.kind;
    data['family'] = this.family;
    data['gender'] = this.gender;
    data['photo'] = this.photo;
    data['country'] = this.country;
    return data;
  }
}
class Carts{
  List<AddCartModel>?cards=[];
  String? code;
  String?version;
  Carts({this.cards,this.code,this.version});
  Carts.fromJson(Map<String, dynamic> json) {
    if (json['cards'] != null) {
      cards = <AddCartModel>[];
      json['cards'].forEach((v) {
        cards!.add(new AddCartModel.fromJson(v));
      });
      code=json["code"];
      version=json["version"];
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cards != null) {
      data['cards'] = this.cards!.map((v) => v.toJson()).toList();
    }
    data["code"]=code;
    data["version"]=version;
    return data;
  }
}