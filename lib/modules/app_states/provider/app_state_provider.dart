

import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../spalshScreen/maintainance_screen.dart';
import '../data/app_state_api.dart';
import 'dart:io' as IO;


class AppStataProviderModel with ChangeNotifier{

  ///.....ui controllers.........
  bool isLoading=false;
  void setIsLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
  /// ...........login............
  bool app_active_state=true;
  bool apple_pay_state=true;

  AppStatesApi appStatesApi=AppStatesApi();
  getAppActiveState(BuildContext context) async {
    setIsLoading(true);
    final url = "https://osta-82ef0-default-rtdb.europe-west1.firebasedatabase.app/alefak_active.json";
    Response response = await Dio().get(url);
    app_active_state=response.data;
  }


  getApplePayState() async {
    setIsLoading(true);
    final url = "https://osta-82ef0-default-rtdb.europe-west1.firebasedatabase.app/alefak_config.json";
    Response response = await Dio().get(url);
      if (IO.Platform.isIOS) {
        if(Constants.APP_VERSION<response.data["app_version"]){
          Constants.APPLE_PAY_STATE=true;
        }else{
          Constants.APPLE_PAY_STATE=response.data['is_payment_enable2'];
        }

      }else{
        Constants.APPLE_PAY_STATE=true;
      }

  }
  getAppUpdateState() async {
    setIsLoading(true);
    final url = "https://osta-82ef0-default-rtdb.europe-west1.firebasedatabase.app/force_update.json";
    Response response = await Dio().get(url);
    Constants.IS_FORCE_UPDATE=response.data;
  }


}