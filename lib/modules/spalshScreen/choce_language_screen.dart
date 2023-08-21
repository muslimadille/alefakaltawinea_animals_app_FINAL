import 'package:alefakaltawinea_animals_app/modules/homeTabsScreen/homeTabsScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/modules/spalshScreen/splash_two_screen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/my_fonts.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/providers.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:alefakaltawinea_animals_app/utils/providers.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/my_utils/baseDimentions.dart';
import '../../utils/my_utils/constants.dart';
import '../../utils/my_utils/myColors.dart';
import '../baseScreen/baseScreen.dart';
import '../introWizard/intro_wizard_screen.dart';
import 'data/regions_api.dart';

class ChoceLanguageScreen extends StatefulWidget {
  const ChoceLanguageScreen({Key? key}) : super(key: key);

  @override
  State<ChoceLanguageScreen> createState() => _ChoceLanguageScreenState();
}

class _ChoceLanguageScreenState extends State<ChoceLanguageScreen> {
  UtilsProviderModel? utilsProviderModel;
  RegionsApi regionsApi=RegionsApi();


  @override
  void initState() {
    super.initState();
    utilsProviderModel =
        Provider.of<UtilsProviderModel>(context, listen: false);

  }

  @override
  Widget build(BuildContext context) {
    utilsProviderModel = Provider.of<UtilsProviderModel>(context, listen: true);
    return BaseScreen(
        tag: "SplashScreen",
        showSettings: false,
        showBottomBar: false,
        body: Stack(
          textDirection:TextDirection.rtl,
          alignment: Alignment.center,
          children: [
            _cartWithAnimalsImage(),
            _blueCart(),
            _textCart(),
            _orangeCart(),
            _dogImage(),
            _bottons()
          ],
        ));
  }
  Widget _textCart(){
    return Positioned(child: Container(
        width: MediaQuery.of(context).size.width,
        child:Column(children: [
          Text('أول بطاقة إلكترونية لخصومات العيادات البيطرية ومتاجر الحيوانات',style: S.h1(color: Colors.white,font: MyFonts.MYRIAD_ARABIC,fontSize: D.textSize(4)),textAlign: TextAlign.center),
          Text('First digital discount card for veterinary clinics and pet shops',style: S.h3(color: Colors.white,font: MyFonts.MYRIAD_ARABIC,fontSize: D.textSize(4)),textAlign: TextAlign.center,)

        ],)),bottom:MediaQuery.of(context).size.height * 0.55 ,);
  }

  Widget _orangeCart() {
    return Positioned(child: TransitionImage(
      "assets/images/orange_splash_bg.png",
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    ),bottom: 0,);
  }

  Widget _blueCart() {
    return Positioned(child: TransitionImage(
      "assets/images/blue_splash_bg.png",
      height: MediaQuery.of(context).size.height * 0.65,
      width: MediaQuery.of(context).size.width,
      fit: BoxFit.fill,
    ),bottom: 0,);
  }
  Widget _dogImage() {
    return Positioned(child: TransitionImage(
      "assets/images/spalsh_dog.png",
      height: MediaQuery.of(context).size.height * 0.28,
      fit: BoxFit.fitHeight,
    ),bottom: 0,right: -D.default_40,);
  }
  Widget _cartWithAnimalsImage() {
    return Positioned(child: TransitionImage(
      "assets/images/cart_with_animals.png",
      height: MediaQuery.of(context).size.height * 0.22,
      fit: BoxFit.fitHeight,
    ),top:D.default_10,);
  }

  Widget _bottons() {
    return Positioned(child: Container(

      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _button("عربي", () async {
          await utilsProviderModel!.setCurrentLocal(
              context, Locale("ar", "EG"));
          setState(() {
            getRegions();
            getAppInfo();
          });
          if(Constants.prefs!.getBool(Constants.IS_FIRST_TIME)??true){
            MyUtils.navigate(context, IntroWizardScreen());
          }else{
            MyUtils.navigate(context, OnBoardingScreen());
          }
        },

        ),
        SizedBox(
          height: D.default_10,
        ),
        _button("English", () async {

          await utilsProviderModel!.setCurrentLocal(
              context, Locale("en", "US"));
            await getRegions();
            getAppInfo();

          if(Constants.prefs!.getBool(Constants.IS_FIRST_TIME)??true){
            MyUtils.navigateReplaceCurrent(context, IntroWizardScreen());
          }else{
            MyUtils.navigate(context, OnBoardingScreen());
          }        })
      ],),),bottom: MediaQuery.of(context).size.height*0.30,);
  }

  Widget _button(String title, Function ontClick) {
    return InkWell(onTap: () {
      ontClick();
    }, child: Container(
      padding: EdgeInsets.all(D.default_5),
      height: D.height(7.5),
      width: D.height(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(D.default_100),),
      ),
      child: Center(child: Container(
        padding: EdgeInsets.all(D.default_5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(D.default_100),),
          color: Colors.white,
        ),
        child: Center(child: Text(title, style: S.h1Bold(fontSize:D.h2,color: C.BASE_BLUE,font: MyFonts.ArabicUiTextLight),
          textAlign: TextAlign.center,),),

      ),),
    ));
  }

   getRegions()async{
    Constants.STATES.clear();
    await regionsApi!.getRegions().then((value) {
      Constants.REGIONS=value.data;
      for(int i=0;i<Constants.REGIONS.length;i++){
        Constants.STATES.addAll( Constants.REGIONS[i].getStates!);
      }
    });

  }
   getAppInfo()async{
    await regionsApi!.getAppInfo().then((value) {
      Constants.APP_INFO=value.data;
    });

  }
}
