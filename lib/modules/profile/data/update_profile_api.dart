
import 'dart:convert';
import 'package:alefakaltawinea_animals_app/data/dio/dio_utils.dart';
import 'package:alefakaltawinea_animals_app/data/dio/my_rasponce.dart';
import 'package:alefakaltawinea_animals_app/modules/login/data/user_data.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';

class UpdateProfileApi{

  Future<MyResponse<UserData>> updateProfile(String name,String email,String phone,int regionId,int stateId) async {
    final url = "${Apis.UPDATE_PROFILE}";
    Map<String,dynamic>body={
      "username":name,
      "email":email,
      "phone":phone,
      "region_id":regionId.toString(),
      "state_id":stateId.toString(),
    };
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {

      return MyResponse<UserData>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<UserData>.init(response!.statusCode.toString(),response.statusMessage!, null);
    }
  }
  Future<MyResponse<dynamic>> changePassword(String oldPassword,String newPassword,String confPassword) async {
    final url = "${Apis.CHANGE_PASSWORD}";
    Map<String,dynamic>body={
      "old_password":oldPassword,
      "password":newPassword,
      "password_confirmation":confPassword,
    };
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {
      return MyResponse<dynamic>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<dynamic>.init(response!.statusCode.toString(),response.statusMessage!, null);
    }
  }

  Future<MyResponse<dynamic>> resetPassword(String newPassword,String confPassword,String code,String phone) async {
    final url = "${Apis.FORGET_PASSWORD}";
    Map<String,dynamic>body={
      "password":newPassword,
      "password_confirmation":confPassword,
      "activation_code":code,
      "phone":phone
    };
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {
      return MyResponse<dynamic>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<dynamic>.init(response!.statusCode.toString(),response.statusMessage!, null);
    }
  }
  Future<MyResponse<dynamic>> deleteAccount(String password) async {
    final url = "${Apis.DELETE_ACCOUNT}";
    Map<String,dynamic>body={
      "old_password":password,
    };
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_POST, url,body: body);
    if (response != null && response.statusCode == 200) {
      return MyResponse<dynamic>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<dynamic>.init(response!.statusCode.toString(),response.statusMessage!, null);
    }
  }


}