import 'dart:convert';
import 'package:dio/dio.dart';

import '../../data/dio/dio_utils.dart';
import '../../data/dio/my_rasponce.dart';
import '../../utils/my_utils/apis.dart';
import '../offers/offer_details/offer_code_model.dart';
import 'add_cart_model.dart';
import 'add_cart_respose_model.dart';
import 'cobon_model.dart';
import 'my_carts_model.dart';

class CartApi{
  Future<MyResponse<String>> uploadCartImage(FormData body) async {
    final url = "${Apis.UPLOAD_CART_IMAGE}";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {
      return MyResponse<String>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<String>.init(Apis.CODE_ERROR, "", null);
    }
  }
  Future<MyResponse<AddCartResponseModel>> addCart(Carts carts,String cobon) async {
    final url = "${Apis.ADD_CART}";
    carts.code=cobon;
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: carts.toJson());
    if (response != null && response.statusCode == 200) {
      return MyResponse<AddCartResponseModel>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<AddCartResponseModel>.init(Apis.CODE_ERROR, "", null);
    }
  }

  Future<MyResponse<dynamic>> editeCart(
      {
        required int id,
        required AddCartModel model
      }) async {
    Map<String,dynamic>body={};
    body["name"]=model.name??"";
    body["kind"]=model.kind??"";
    body["family"]=model.family??"";
    body["gender"]=model.gender??"";
    body["country"]=model.country??"";
    body["photo"]=model.photo??"";

    final url = "${Apis.EDITE_CARD}/$id";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {
      return MyResponse<dynamic>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<dynamic>.init(Apis.CODE_ERROR, "", null);
    }
  }
  Future<MyResponse<bool>> deleteCarts(int cardId) async {
    final url = "${Apis.DELETE_CARD}/$cardId";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<bool>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<bool>.init(Apis.CODE_ERROR, "", null);
    }
  }

  Future<MyResponse<MyCartsModel>> getMyCarts() async {
    final url = "${Apis.USER_CART}";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<MyCartsModel>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<MyCartsModel>.init(Apis.CODE_ERROR, "", null);
    }
  }
  Future<MyResponse<OfferCodeModel>> useCode(int shop_id,int offer_id,int card_id) async {
    final url = "${Apis.USE_OFFER}";
    Map<String,dynamic>body={
      "shop_id":shop_id,
      "offer_id":offer_id,
      "card_id":card_id
    };
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {
      return MyResponse<OfferCodeModel>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<OfferCodeModel>.init(Apis.CODE_ERROR, "", null);
    }
  }
  Future<MyResponse<CobonModel>> checkCobon(String cobon) async {
    final url = "${Apis.CHECK_COBON}";
    Map<String,String>body={
      "code":cobon
    };
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {
      return MyResponse<CobonModel>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<CobonModel>.init(Apis.CODE_ERROR, "", null);
    }
  }

}