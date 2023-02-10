
import 'dart:convert';
import 'package:alefakaltawinea_animals_app/data/dio/dio_utils.dart';
import 'package:alefakaltawinea_animals_app/data/dio/my_rasponce.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';

class GetServiceProvidersApi{

  Future<MyResponse<ServiceProviderModel>> getServiceProviders(int categoryId,int page,{String lat="",String long="",String keyword="",String state_id=""}) async {
    String url = "${Apis.GET_SERVICE_PROVIDERS_LIST}/${categoryId}?page=${page}"; //keyword=&region_id=&state_id
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<ServiceProviderModel>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<ServiceProviderModel>.init(Apis.CODE_ERROR, "", null);
    }
  }
  Future<MyResponse<ServiceProviderModel>> getSearch(int categoryId,int page,{String lat="",String long="",String keyword="",String state_id=""}) async {
    String url = "${Apis.GET_SERVICE_PROVIDERS_LIST}/${categoryId}?page=${page}&latitude=${lat}&longitude=${long}&keyword=${keyword}"; //keyword=&region_id=&state_id
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<ServiceProviderModel>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<ServiceProviderModel>.init(Apis.CODE_ERROR, "", null);
    }
  }
  Future<MyResponse<List<Data>>> getClosest(int categoryId,String lat,String long) async {
    final url = "${Apis.GET_SERVICE_PROVIDERS_LIST}/${categoryId}?latitude=${lat}&longitude=${long}";//keyword=&region_id=&state_id
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<List<Data>>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<List<Data>>.init(Apis.CODE_ERROR, "", null);
    }
  }
  Future<MyResponse<Data>> getServiceProvider(int id) async {
    String url = "${Apis.GET_SERVICE_PROVIDER}/$id}";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<Data>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<Data>.init(Apis.CODE_ERROR, "", null);
    }
  }


}