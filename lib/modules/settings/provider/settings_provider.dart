import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../data/dio/my_rasponce.dart';
import '../../../utils/my_utils/apis.dart';
import '../apl/settings_api.dart';

class SettingsProvider with ChangeNotifier{
  ///.....ui controllers.........
  bool isLoading=false;

  void setIsLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
  SettingsApi settingsApi=SettingsApi();
  contactUs(BuildContext ctx, String name, String message, String phone, String contact_time,) async {
    setIsLoading(true);
    MyResponse<dynamic> response =
    await settingsApi.contactUs(name, message, phone, contact_time);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
      Navigator.pop(ctx);
    }
      else{
        setIsLoading(false);
        await Fluttertoast.showToast(msg: "${response.msg}");
      }
    notifyListeners();
    }

  registerShop(BuildContext ctx, String name, String address, String phone, String manager_name) async {
    setIsLoading(true);
    MyResponse<dynamic> response =
    await settingsApi.registerShop(name, address, phone, manager_name);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
      Navigator.pop(ctx);
    }
    else{
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
    }
    notifyListeners();
  }
  }


