import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/registeration/registration_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/settings/privacy_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/settings/terms_screen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/providers.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/action_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/my_utils/apis.dart';
import '../cart/add_cart_screen.dart';
import '../login/provider/user_provider_model.dart';
import '../spalshScreen/spalshScreen.dart';
import 'about_screen.dart';
import 'add_store_screen.dart';
import 'contact_us_screen.dart';


class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UtilsProviderModel? utilsProviderModel;
  UserProviderModel? userProviderModel;

  bool _showLangAlert=false;
  @override
  void initState() {
    super.initState();
    userProviderModel=Provider.of<UserProviderModel>(context,listen: false);
  }
  @override
  Widget build(BuildContext context) {
    userProviderModel=Provider.of<UserProviderModel>(context,listen: true);
    utilsProviderModel=Provider.of<UtilsProviderModel>(context,listen: true);
    return Stack(children: [
      BaseScreen(
        showSettings: false,
        showBottomBar: true,
        tag: "SettingScreen",
        body: Container(
          child: Column(
            children: [
              ActionBarWidget(tr("Settings_title"), context,showSetting: false,),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(D.default_10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: D.default_10,),
                        _itemText(tr("about_app"), () {
                          MyUtils.navigate(context, AboutAppScreen());
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _itemText(tr("select_language"), (){}),
                            Container(
                                width: D.default_150,
                                padding: EdgeInsets.only(left:D.default_10,right: D.default_10,top: D.default_5,bottom: D.default_5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(D.default_100),
                                    color: C.BASE_BLUE,
                                    boxShadow:[BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        offset:Offset(1,1),
                                        blurRadius:1,
                                        spreadRadius: 0.5
                                    )]
                                ),
                                child: InkWell(
                                  onTap: (){
                                    MyUtils.languageDialog(context, _changeLnguagesAlertBody(),utilsProviderModel!,isDismissible:true);
                                  },
                                  child: Center(child: Text(Constants.utilsProviderModel!.currentLocalName,style: S.h3(color: Colors.white),),),)

                            )
                          ],),
                        Constants.currentUser!=null?Constants.currentUser!.userTypeId!="6"?_itemText(tr("buy_card"), () {
                          if(Constants.currentUser==null){
                            MyUtils.navigate(context, RegistrationScreen());
                          }else{
                            MyUtils.navigate(context, AddCartScreen());
                          }
                        }):Container():Container(),
                        Constants.currentUser!=null?Constants.currentUser!.userTypeId!="6"?_itemText(tr("add_your_shop"), (){
                          MyUtils.navigate(context, AddStoreScreen());
                        }):Container():Container(),
                        _itemText(tr("contact_us"), () {
                          MyUtils.navigate(context, ContactUsScreen());
                        }),
                         _itemText(tr("Terms_and_Conditions"), (){
                          MyUtils.navigate(context, TermsScreen());
                        }),
                        _itemText(tr("Privacy_screen_title"), (){
                          MyUtils.navigate(context, PrivacyScreen());
                        }),
                        Constants.currentUser!=null?Constants.currentUser!.userTypeId.toString()=="6"? _itemText(tr("logout"), ()async{
                          UserProviderModel().logout(context);
                          /*await Constants.prefs!.setString(Constants.TOKEN_KEY!,"");
                          Apis.TOKEN_VALUE="";
                          userProviderModel!.currentUser=null;
                          Constants.currentUser=null;
                          MyUtils.navigateAsFirstScreen(context, SplashScreen());*/
                        }):Container():Container()
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      _showLangAlert?_changeLnguagesAlertBody():Container()
    ],);
  }

  Widget _itemText(String title, Function onClick) {
    return InkWell(onTap: (){
      onClick();
    },child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.all(D.default_15),
            child: Text(title, style: S.h2(color: Colors.black)))
      ],
    ),);
  }
  Widget _changeLnguagesAlertBody(){
    bool arStat=Constants.utilsProviderModel!.isArabic;
    bool enStat=Constants.utilsProviderModel!.isEnglish;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.5),
      child: Center(child:Container(

        height: D.default_300,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(D.default_10),
              child: Text(tr("select_language"),style: S.h2(color: Colors.black),textAlign:TextAlign.start ,),),
            _devider(),
            Container(
                padding: EdgeInsets.all(D.default_10),
                child: Row(children: [
                  Radio(value: true, groupValue:arStat,toggleable: true, onChanged: ( val ){

                    bool currentValue=val as bool ;
                    arStat=currentValue;
                    currentValue?utilsProviderModel!.setLanguageState("ar"):utilsProviderModel!.setLanguageState("en");
                    setState(() {

                    });
                  }),
                  Text("العربية", style: S.h2(color: Colors.black))
                ],)),
            _devider(),
            Container(
                padding: EdgeInsets.all(D.default_10),
                child: Row(children: [
                  Radio(value: true, groupValue:enStat, toggleable: true,onChanged: ( val ){
                    bool currentValue=val as bool ;
                    enStat=currentValue;
                    currentValue?utilsProviderModel!.setLanguageState("en"):utilsProviderModel!.setLanguageState("ar");
                    setState(() {

                    });
                  }),
                  Text("English", style: S.h2(color: Colors.black))
                ],)),
          ],))),);
  }
  Widget _devider(){
    return Container(width: double.infinity,height: D.default_1,color: Colors.grey,);
  }
}
