

import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
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
    bool response =
    await appStatesApi.getActiveState();
    app_active_state=response;
    if(app_active_state){
      MyUtils.navigateAsFirstScreen(context, MaintainanceScreen());
    }
    notifyListeners();

  }
  getApplePayState() async {
    setIsLoading(true);
    Map<String,dynamic> response =
    await appStatesApi.getApplePayState()  ;
    if (IO.Platform.isIOS) {
      if(Constants.APP_VERSION<response["app_version"]){
        Constants.APPLE_PAY_STATE=true;
      }else{
        Constants.APPLE_PAY_STATE=response['is_payment_enable2'];
      }

    }else{
      Constants.APPLE_PAY_STATE=true;
    }
    notifyListeners();

  }

}