import 'package:alefakaltawinea_animals_app/data/dio/my_rasponce.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/mainCategoriesScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/login/data/login_api.dart';
import 'package:alefakaltawinea_animals_app/modules/login/data/user_data.dart';
import 'package:alefakaltawinea_animals_app/modules/login/login_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/otp/otp_screem.dart';
import 'package:alefakaltawinea_animals_app/modules/otp/phone_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/profile/data/update_profile_api.dart';
import 'package:alefakaltawinea_animals_app/modules/registeration/data/registeration_api.dart';
import 'package:alefakaltawinea_animals_app/modules/spalshScreen/spalshScreen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';


import '../../intro/intro_screen.dart';
import '../../serviceProviderAccount/SpHomeScreen.dart';
import '../../spalshScreen/splash_two_screen.dart';

class UserProviderModel with ChangeNotifier{

  ///.....ui controllers.........
  bool isLoading=false;
  void setIsLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
  /// ...........login............
  UserData? currentUser;
  LoginApi loginApi=LoginApi();
  UpdateProfileApi updateProfileApi=UpdateProfileApi();
  login(String phone,String password,BuildContext ctx,bool isSplash) async {
    setIsLoading(true);
    MyResponse<UserData> response =
    await loginApi.login(phone, password);

    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      UserData user=response.data;
       if(user.activate=="1"){
         setCurrentUserData(user);
         setIsLoading(false);
         await Constants.prefs!.setString(Constants.SAVED_PHONE_KEY!,phone);
         await Constants.prefs!.setString(Constants.SAVED_PASSWORD_KEY!,password);
         if(user.userTypeId.toString()=="6"){
           MyUtils.navigateAsFirstScreen(ctx, SpHomeScreen());
         }else{
           bool isShowed=await Constants.prefs!.getBool("intro${Constants.currentUser!.id}")??false;
           if(!isShowed&&Constants.APPLE_PAY_STATE){
             MyUtils.navigateAsFirstScreen(ctx, IntroScreen());
           }else{
             MyUtils.navigateAsFirstScreen(ctx, MainCategoriesScreen());
           }
         }
       }else{
         setIsLoading(false);
         /// NAVIGATE TO SMS SCREEN
         MyUtils.navigate(ctx, PhoneScreen(tr("login"), tr("register_otp")));
       }

          }else if(response.status == Apis.CODE_ACTIVE_USER){
      setIsLoading(false);
      /// NAVIGATE TO SMS SCREEN
      MyUtils.navigate(ctx, PhoneScreen(tr("login"), tr("register_otp")));
    }else if(response.status == Apis.CODE_SHOW_MESSAGE ){

      print("login error: ${response.msg}");
      setIsLoading(false);
      if(!isSplash){
        await Fluttertoast.showToast(msg: "${response.msg}");
        MyUtils.navigateAsFirstScreen(ctx, OnBoardingScreen());
      }

    }
    notifyListeners();

  }
setCurrentUserData(UserData user,){
  currentUser=user;
  Constants.currentUser=user;
  Apis.TOKEN_VALUE=user.token!;
  notifyListeners();
}
/// ............REGISTER...............
  RegisterationApi registerationApi=RegisterationApi();
  register(BuildContext ctx,String name,String email,String phone,String password,String confirmPass,{int regionId=1,int stateId=1,bool fromaddcard=false}) async {
    setIsLoading(true);
    MyResponse<UserData> response =
    await registerationApi.register( name, email, phone, password, confirmPass, regionId:3, stateId:3155);
    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      UserData user=response.data;
      setCurrentUserData(user);
      await Constants.prefs!.setString(Constants.SAVED_PHONE_KEY!,phone);
      await Constants.prefs!.setString(Constants.SAVED_PASSWORD_KEY!,password);
      setIsLoading(false);
      MyUtils.navigateReplaceCurrent(ctx, OtpScreen("register",tr('register_otp'),code:response.code.toString(),fromaddcard:fromaddcard ,));
    }else if(response.status == Apis.CODE_ACTIVE_USER &&response.data!=null){
      UserData user=response.data;
      setCurrentUserData(user);
      setIsLoading(false);
      MyUtils.navigateReplaceCurrent(ctx, OtpScreen("register",tr('register_otp'),code:response.code.toString(),fromaddcard:fromaddcard ));
    }else if(response.status == Apis.CODE_SHOW_MESSAGE ){
      print("login error: ${response.msg}");
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
    }
    notifyListeners();

  }
/// ...........update profile............
  updateProfile(BuildContext ctx,String name,String email,String phone,{ int regionId=1,int stateId=1}) async {
    setIsLoading(true);
    MyResponse<UserData> response =
    await updateProfileApi.updateProfile( name, email, phone,regionId,stateId);

    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      UserData user=response.data;
      setCurrentUserData(user);
      setIsLoading(false);
      if(user.activate=="0"){
        MyUtils.navigateAsFirstScreen(ctx, OtpScreen("update",tr('register_otp'),code:response.code.toString(),));
      }
    }else if(response.status == Apis.CODE_ACTIVE_USER &&response.data!=null){
      UserData user=response.data;
      setCurrentUserData(user);
      setIsLoading(false);
      MyUtils.navigateReplaceCurrent(ctx, OtpScreen("register",tr('register_otp'),code:response.code.toString(),));
    }else if(response.status == Apis.CODE_SHOW_MESSAGE ){
      print("login error: ${response.msg}");
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
    }
    notifyListeners();

  }

  changePassword(BuildContext ctx,String oldPassword,String newPassword,String confPassword) async {
    setIsLoading(true);
    MyResponse<dynamic> response =
    await updateProfileApi.changePassword( oldPassword, newPassword, confPassword);

    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      Constants.prefs!.clear();
      Constants.currentUser!=null;
      MyUtils.navigateAsFirstScreen(ctx, SplashScreen());

    }else if(response.status == Apis.CODE_SHOW_MESSAGE ){
      print("login error: ${response.msg}");
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
    }
    notifyListeners();

  }
  resetPassword(BuildContext ctx,String newPassword,String confPassword,String code,String phone) async {
    setIsLoading(true);
    MyResponse<dynamic> response =
    await updateProfileApi.resetPassword(newPassword, confPassword,code,phone);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      Constants.prefs!.clear();
      Constants.currentUser=null;
      MyUtils.navigate(ctx, LoginScreen());

    }else if(response.status == Apis.CODE_SHOW_MESSAGE ){
      print("login error: ${response.msg}");
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
    }
    notifyListeners();

  }
  deleteAccount(BuildContext ctx,String password) async {
    setIsLoading(true);
    MyResponse<dynamic> response =
    await updateProfileApi.deleteAccount(password);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      Constants.prefs!.clear();
      Constants.currentUser=null;
      MyUtils.navigate(ctx, LoginScreen());

    }else if(response.status == Apis.CODE_SHOW_MESSAGE ){
      print("login error: ${response.msg}");
      setIsLoading(false);
      await Fluttertoast.showToast(msg: "${response.msg}");
    }
    notifyListeners();

  }


}