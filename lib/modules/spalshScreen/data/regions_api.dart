
import 'dart:convert';
import 'package:alefakaltawinea_animals_app/data/dio/dio_utils.dart';
import 'package:alefakaltawinea_animals_app/data/dio/my_rasponce.dart';
import 'package:alefakaltawinea_animals_app/modules/login/data/user_data.dart';
import 'package:alefakaltawinea_animals_app/modules/spalshScreen/data/regions_model.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';

import 'app_info_model.dart';

class RegionsApi{

  Future<MyResponse<List<RegionsModel>>> getRegions() async {
    final url = "${Apis.GET_REGIONS}";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<List<RegionsModel>>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<List<RegionsModel>>.init(response!.statusCode.toString(),response.statusMessage!, null);
    }
  }
  Future<MyResponse<AppInfoModel>> getAppInfo() async {
    final url = "${Apis.GET_APP_INFO}/";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return MyResponse<AppInfoModel>.fromJson(
          json.decode(jsonEncode(response.data)));
    } else {
      return MyResponse<AppInfoModel>.init(response!.statusCode.toString(),response.statusMessage!, null);
    }
  }
}