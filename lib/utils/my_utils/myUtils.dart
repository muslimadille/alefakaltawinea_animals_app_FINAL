
import 'package:alefakaltawinea_animals_app/modules/login/data/user_data.dart';
import 'package:alefakaltawinea_animals_app/modules/login/provider/user_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/spalshScreen/spalshScreen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../modules/categories_screen/mainCategoriesScreen.dart';
import '../../modules/settings/change_language_dialog_widget.dart';
import '../../modules/settings/regions_dialog_widget.dart';
import '../../modules/spalshScreen/data/regions_model.dart';
import 'baseDimentions.dart';
import 'baseTextStyle.dart';
import 'myColors.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter_share/flutter_share.dart';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyUtils{

  /// ........... navigation utils................................
  static void navigate(BuildContext context,Widget screen){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen)).then((value) {
      //Constants.utilsProviderModel!.setCurrentLocal(context, Constants.utilsProviderModel!.currentLocal);
    });
  }
  static void navigateAsFirstScreen(BuildContext context,Widget screen){
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => screen)).then((value) {
      //Constants.utilsProviderModel!.setCurrentLocal(context, Constants.utilsProviderModel!.currentLocal);
    });
  }

  static void navigateReplaceCurrent(BuildContext context,Widget screen){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => screen)).then((value) {
      //Constants.utilsProviderModel!.setCurrentLocal(context, Constants.utilsProviderModel!.currentLocal);
    });
  }
  ///========================intor utils===================================================
  static void printLongLine(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static languageDialog(BuildContext context,Widget body,UtilsProviderModel? utilsProviderModel,
  {bool isDismissible = true,}) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {// return object of type Dialog
        return WillPopScope(
            onWillPop: isDismissible ? _onWillPop : _onWillNotPop,
            child: AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content:ChangeLanguageDialogWidget(),
            ));
      },
    );
  }
  static regionsDialog(BuildContext context) {
    basePopup(context, body: RegionsDialogWidget(onItemSelect: (Get_states ) {  },)) ;
  }
  static Future<bool> _onWillPop() async {
    return  true;
  }

  static Future<bool> _onWillNotPop() async {
    return  false;
  }
  static Future<void> share() async {
    await FlutterShare.share(
        title: 'تطبيق أليفك ',
        linkUrl: Constants.APP_LINK);
  }
  static openwhatsapp(BuildContext context) async{
    var whatsapp ="${Constants.APP_INFO!.whatsapp}";
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("")}";
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
        await launch(whatappURL_ios, forceSafariVC: false);
      }else{
        await Fluttertoast.showToast(msg: "الرجاء تنزيل whatsapp لتتمكن من التواصل معنا");
      }
    }else{
      // android , web
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
        await Fluttertoast.showToast(msg: "الرجاء تنزيل whatsapp لتتمكن من التواصل معنا");

      }
    }
  }
  static void basePopup(BuildContext context,{required Widget body, EdgeInsetsGeometry? padding}) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // set to false
        pageBuilder: (_, __, ___) {
          return
            Scaffold(
                backgroundColor: Colors.white.withOpacity(0.5),
              body:SafeArea(child: Container(
              color: Colors.black.withOpacity(0.5),
              padding: padding ?? EdgeInsets.all(D.default_20),
              child: Center(child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  body
                ],)),)));
        },
      ),
    );
  }
  static String replaceArabicNumber(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(arabic[i], english[i]);
    }
    print("$input");
    return input;
  }

}

