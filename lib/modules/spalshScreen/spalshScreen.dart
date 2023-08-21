
import 'dart:io';

import 'package:alefakaltawinea_animals_app/modules/ads/provider/ads_slider_provider.dart';
import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/mainCategoriesScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/homeTabsScreen/homeTabsScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/homeTabsScreen/provider/intro_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/intro/intro_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/login/login_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/login/provider/user_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/registeration/registration_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviderAccount/SpHomeScreen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/providers.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/update_app_popup.dart';
import 'package:alefakaltawinea_animals_app/utils/notification/fcm.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_states/provider/app_state_provider.dart';
import '../introWizard/intro_wizard_screen.dart';
import 'choce_language_screen.dart';
import 'data/regions_api.dart';
import 'data/regions_api.dart';
import 'data/regions_api.dart';
import 'maintainance_screen.dart';



class SplashScreen extends StatefulWidget{
  bool? toHome;
   SplashScreen({this.toHome=false,Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  AdsSliderProviderModel?adsSliderProviderModel;
  SharedPreferences? prefs;
  UtilsProviderModel? utilsProviderModel;
  UserProviderModel?userProviderModel;
  RegionsApi regionsApi=RegionsApi();
  AppStataProviderModel?appStataProviderModel;

  @override
  void initState() {
    super.initState();
    appStataProviderModel=Provider.of<AppStataProviderModel>(context,listen:false);
    userProviderModel=Provider.of<UserProviderModel>(context,listen: false);
    adsSliderProviderModel=Provider.of<AdsSliderProviderModel>(context,listen: false);
    if(Platform.isIOS){
      Constants.DEVICE_TYPE="ios";
    }else{
      Constants.DEVICE_TYPE="android";
    }
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await _initPref(context);
      await FCM().notificationSubscrib(Constants.prefs!.get(Constants.LANGUAGE_KEY!)=="ar");
      await adsSliderProviderModel!.getAdsSlider();
      await appStataProviderModel!.getAppActiveState(context);
      await appStataProviderModel!.getApplePayState();
      await appStataProviderModel!.getAppUpdateState();
      if(Constants.IS_FORCE_UPDATE){
        MyUtils.basePopup(context, body: UpdateAppPopup(content: tr("update"),onOkPressed: (){
          Future.delayed(Duration(milliseconds: 100)).then((value){
      if(Platform.isIOS){
        exit(0);
      }else{
        SystemNavigator.pop();
      }
          });
        },));
      }else{
        await login();
      }

    });


  }
  @override
  Widget build(BuildContext context) {
    appStataProviderModel=Provider.of<AppStataProviderModel>(context,listen:false);
    utilsProviderModel=Provider.of<UtilsProviderModel>(Constants.mainContext!,listen: true);
    Constants.utilsProviderModel=utilsProviderModel;
    adsSliderProviderModel=Provider.of<AdsSliderProviderModel>(context,listen: true);
    userProviderModel=Provider.of<UserProviderModel>(context,listen: true);


    return BaseScreen(
        tag: "SplashScreen",
      showSettings: false,
        showBottomBar: false,
      showWhatsIcon:false,
        body: Stack(
          alignment:AlignmentDirectional.center,
          children: [
            Container(width: double.infinity,height: double.infinity,color: C.BASE_BLUE,),
            _logoTitleItem(),
            Positioned(child:TransitionImage(
              "assets/images/splash_animals.png",
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.fitHeight,
            ),bottom: 0.0, )

    ],)
    );
  }
  Widget _logoTitleItem(){
    return TransitionImage(
      "assets/images/logo_with_name.png",
      width: D.default_300*0.9,
      height: D.default_300*0.9,
    );
  }



   getRegions()async{
    Constants.STATES.clear();
    await regionsApi.getRegions().then((value) {
      Constants.REGIONS=value.data;
      for(int i=0;i<Constants.REGIONS.length;i++){
        Constants.STATES.addAll( Constants.REGIONS[i].getStates!);
      }
    });

  }
   getAppInfo()async{
    await regionsApi.getAppInfo().then((value) {
      Constants.APP_INFO=value.data;
    });

  }
   _initPref(BuildContext ctx)async{
    if((Constants.prefs!.getString(Constants.TOKEN_KEY!)??'').isNotEmpty){
      Apis.TOKEN_VALUE=Constants.prefs!.getString(Constants.TOKEN_KEY!)??'';
    }
    if(Constants.prefs!.get(Constants.LANGUAGE_KEY!)!=null){
      if(Constants.prefs!.get(Constants.LANGUAGE_KEY!)=="ar"){
        utilsProviderModel!.setLanguageState("ar");
        utilsProviderModel!.setCurrentLocal(ctx, Locale('ar','EG'));
      }else{
        utilsProviderModel!.setLanguageState("en");
        utilsProviderModel!.setCurrentLocal(ctx, Locale('en','US'));
      }
    }else{
      utilsProviderModel!.setLanguageState("ar");
      utilsProviderModel!.setCurrentLocal(ctx, Locale('ar','EG'));
    }

  }
  void setLocal()async{
    if(utilsProviderModel!.isArabic){
      await context.setLocale(Locale('ar', 'EG'));
      await EasyLocalization.of(context)!.setLocale(Locale('ar', 'EG'));
      utilsProviderModel!.currentLocalName="العربية";
      Constants.SELECTED_LANGUAGE="ar";
      await utilsProviderModel!.setLanguageState("ar");
      await Constants.prefs!.setString(Constants.LANGUAGE_KEY!, "ar");
    }else{
      await context.setLocale(Locale('en', 'US'));
      await EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
      utilsProviderModel!.currentLocalName="English";
      Constants.SELECTED_LANGUAGE="en";
      utilsProviderModel!.setLanguageState("en");
      await Constants.prefs!.setString(Constants.LANGUAGE_KEY!, "en");
    }
  }
   login()async{
    await UserProviderModel().getSavedUser(context).then((value)async{
      await FCM().openClosedAppFromNotification();
      await getRegions();
      await getAppInfo();
      if(value){
        if(Constants.currentUser!.userTypeId.toString()=="6"){
          MyUtils.navigateAsFirstScreen(context, SpHomeScreen());
        }
        else{
          bool isShowed=await Constants.prefs!.getBool("intro${Constants.currentUser!.id}")??false;
          if(!isShowed&&Constants.APPLE_PAY_STATE){
            MyUtils.navigateAsFirstScreen(context, IntroScreen());
          }else{
            if(appStataProviderModel!.app_active_state){
              MyUtils.navigateAsFirstScreen(context, MaintainanceScreen());
            }else{
              if(widget.toHome??false){
                MyUtils.navigateReplaceCurrent(context, MainCategoriesScreen());
              }else{
                if(value){
                  MyUtils.navigateReplaceCurrent(context, MainCategoriesScreen());

                }else{
                  MyUtils.navigateReplaceCurrent(context, ChoceLanguageScreen());

                }
              }
            }
          }
        }
      }else{
        MyUtils.navigateReplaceCurrent(context, ChoceLanguageScreen());
      }





    });
  }
}
