
import 'dart:convert';
import 'package:alefakaltawinea_animals_app/data/dio/dio_utils.dart';
import 'package:alefakaltawinea_animals_app/data/dio/my_rasponce.dart';
import 'package:alefakaltawinea_animals_app/modules/login/data/user_data.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';

class AppStatesApi{

  Future<bool> getActiveState() async {
    final url = "https://osta-82ef0-default-rtdb.europe-west1.firebasedatabase.app/alefak_active.json";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return json.decode(jsonEncode(response.data));
    } else {
      return false;
    }
  }
  Future<Map<String,dynamic>> getApplePayState() async {
    final url = "https://osta-82ef0-default-rtdb.europe-west1.firebasedatabase.app/alefak_config.json";
    final response = await BaseDioUtils.request(BaseDioUtils.REQUEST_GET, url);
    if (response != null && response.statusCode == 200) {
      return json.decode(jsonEncode(response.data));
    } else {
      return {};
    }
  }
}