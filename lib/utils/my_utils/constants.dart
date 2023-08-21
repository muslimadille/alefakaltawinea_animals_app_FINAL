import 'package:alefakaltawinea_animals_app/modules/login/data/user_data.dart';
import 'package:alefakaltawinea_animals_app/modules/spalshScreen/data/regions_model.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../modules/spalshScreen/data/app_info_model.dart';

class Constants extends Object{
  static String? SELECTED_LANGUAGE="ar";
  static String? LANGUAGE_KEY="LANGUAGE_KEY";
  static String? DEVICE_TYPE="";
  static double APP_VERSION=192;


  static   SharedPreferences? prefs ;
  static  UserData? currentUser;
  static int OTP_LENGTH=4;
  //static String? SAVED_PHONE_KEY="SAVED_PHONE";
  static String? SAVED_USER_KEY="SAVED_USER";
  //static String? SAVED_PASSWORD_KEY="SAVED_PASSWORD";
  static List<RegionsModel> REGIONS=[];
  static List<Get_states> STATES=[];
  static int currentState=currentUser!=null?int.parse(currentUser!.stateId!.isNotEmpty?currentUser!.stateId??"0":"0"):REGIONS[0].getStates![0].id!;
  static String MAPS_API_KEY="AIzaSyDuvS1cZBr4opbX8FmSRyuuKixykzVY3So";
  static bool show_adoption_alert=false;
  static AppInfoModel? APP_INFO;
  static String APP_LINK="https://drive.google.com/file/d/1MTmSYV6-3lBBffcsyZ_g5whBIT_dio3f/view?usp=sharing";
  static String isAdoptionAlertAccepted="isAdoptionAlertAccepted";
  static BuildContext? mainContext;
  static bool APPLE_PAY_STATE=true;
  static String IS_FIRST_TIME="IS_FIRST_TIME";
  static String TERMS_CHECK="TERMS_CHECK";
  static double DEVICE_RATIO=0.0;
  static double DEVICE_HEIGHT=0.0;
  static double DEVICE_WIDTH=0.0;
  static bool IS_FORCE_UPDATE=false;
  static String? TOKEN_KEY="TOKEN_KEY";




  ///888888888888888888888888888888888888888888888888888888
  static UtilsProviderModel? utilsProviderModel;







}