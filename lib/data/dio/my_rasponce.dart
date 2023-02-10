
import 'package:alefakaltawinea_animals_app/modules/adoption/data/adoption_categories_model.dart';
import 'package:alefakaltawinea_animals_app/modules/adoption/data/animal_pager_list_model.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/data/categories_model.dart';
import 'package:alefakaltawinea_animals_app/modules/login/data/user_data.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/modules/spalshScreen/data/regions_model.dart';

import '../../modules/cart/add_cart_respose_model.dart';
import '../../modules/cart/cobon_model.dart';
import '../../modules/cart/my_carts_model.dart';
import '../../modules/notifications/data/notification_model.dart';
import '../../modules/offers/offer_details/offer_code_model.dart';
import '../../modules/serviceProviderAccount/data/scan_code_model.dart';
import '../../modules/spalshScreen/data/app_info_model.dart';

class MyResponse<T> extends Object {
  final TAG = "MyResponse";

  String? _status = "";
  String? _msg = "";
  var _data;
  int?_activation_code;



  MyResponse.fromJson(Map<String, dynamic> json) {
    print("$TAG: ${json.toString()}");
    if (json.containsKey("activation_code")) {
      _activation_code = json['activation_code'];
    }
    if (json.containsKey("status")) {
      _status = json['status'].toString();
    }
    if (json.containsKey("Error")) {
      _msg = json['Error'];
    } else if (json.containsKey("error")) {
      _msg = json['error'];
    }
    if (json.containsKey("message")) {
      _msg = json['message'];
    }
    if (json.containsKey("Data")) {
      if(_status=="400"){
        _data=null;
      }else{
        _checkType(json['Data']);
      }
    } else if (json.containsKey("data")) {
      if(_status=="400"){
        _data=null;
      }else{
        if(json['data'].toString()=="[]"){
          _data=null;
        }else{
          _checkType(json['data']);
        }
      }    }


  }

  MyResponse.init(String status, String msg, dynamic data, {int? code}) {
    _status = status;
    _msg = msg;
    _activation_code=code;
    if (data is int) {
      _status = "$data";
    } else {
      if(_status!="200"){
        _data=null;
      }else{
        _data = data;
      }
    }
  }

  _checkType(json) {
    print("$TAG-T_Type: $T");

    if (json != null) {
      if (!_parseList(json)) {
        _parseSingle(json);
      }
    } else {
      _data = null;
    }
  }

  _parseSingle(json) {
    switch (T) {
      case ServiceProviderModel:
        _data = ServiceProviderModel.fromJson(json) as T;
        break;
      case UserData:
        _data = UserData.fromJson(json) as T;
        break;
      case AnimalPagerListModel:
        _data = AnimalPagerListModel.fromJson(json) as T;
        break;
      case AppInfoModel:
        _data = AppInfoModel.fromJson(json) as T;
        break;
      case AddCartResponseModel:
        _data = AddCartResponseModel.fromJson(json) as T;
        break;
      case MyCartsModel:
        _data = MyCartsModel.fromJson(json) as T;
        break;
      case String:
        _data = json as T;
        break;
      case OfferCodeModel:
        _data = OfferCodeModel.fromJson(json) as T;
        break;
      case ScanCodeModel:
        _data = ScanCodeModel.fromJson(json) as T;
        break;
      case CobonModel:
        _data = CobonModel.fromJson(json) as T;
        break;
      case Data:
        _data = Data.fromJson(json) as T;
        break;

      default:_data = null;
    }
  }

  bool _parseList(json) {
    if ("$T".contains("List<CategoriesDataModel>")) {
      _data = (json as List)
          .map((item) => CategoriesDataModel.fromJson(item))
          .toList() as T;

    }else if("$T".contains("List<Data>")){
      _data = (json as List)
          .map((item) => Data.fromJson(item))
          .toList() as T;
    }
    else if("$T".contains("List<AdoptionCategoriesModel>")){
      _data = (json as List)
          .map((item) => AdoptionCategoriesModel.fromJson(item))
          .toList() as T;
    }
    else if("$T".contains("List<RegionsModel>")){
      _data = (json as List)
          .map((item) => RegionsModel.fromJson(item))
          .toList() as T;
    }
    else if("$T".contains("List<NotificationModel>")){
      _data = (json as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList() as T;
    }
    else {
      _data = null;
      return false;
    }
    print(_data);
    return true;
  }

  String? get status => _status;

  String? get msg => _msg;
  int? get code => _activation_code;

  get data => _data;
  set data(value) => _data = value;
}
