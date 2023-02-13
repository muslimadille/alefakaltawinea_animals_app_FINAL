import 'package:alefakaltawinea_animals_app/modules/ads/ads_slider.dart';
import 'package:alefakaltawinea_animals_app/modules/ads/provider/ads_slider_provider.dart';
import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/provider/categories_provider_model.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/laoding_view.dart';
import 'package:alefakaltawinea_animals_app/utils/notification/fcm.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/my_utils/myColors.dart';
import '../../utils/my_utils/myUtils.dart';
import '../../utils/my_utils/providers.dart';
import '../../utils/my_widgets/action_bar_widget.dart';
import '../adoption/adpotion_screen.dart';
import '../spalshScreen/data/regions_api.dart';
import 'items/category_list.dart';
import 'package:sprintf/sprintf.dart';


class MainCategoriesScreen extends StatefulWidget {
  Function? navigateTo;
   MainCategoriesScreen({this.navigateTo});

  @override
  _MainCategoriesScreenState createState() => _MainCategoriesScreenState();
}

class _MainCategoriesScreenState extends State<MainCategoriesScreen> {
  AdsSliderProviderModel?adsSliderProviderModel;

  CategoriesProviderModel?categoriesProviderModel;
  RegionsApi regionsApi=RegionsApi();
  UtilsProviderModel? utilsProviderModel;

  @override
  void initState() {
    super.initState();
    //getRegions();
    categoriesProviderModel=Provider.of<CategoriesProviderModel>(context,listen: false);
    utilsProviderModel=Provider.of<UtilsProviderModel>(context,listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_){
      adsSliderProviderModel!.getAdsSlider();
      categoriesProviderModel!.getCategoriesList();
      notificationNavigation();
    });

  }
   notificationNavigation(){
      widget.navigateTo!=null?widget.navigateTo!():(){};

  }
  @override
  Widget build(BuildContext context) {
    utilsProviderModel=Provider.of<UtilsProviderModel>(context,listen: false);
    categoriesProviderModel=Provider.of<CategoriesProviderModel>(context,listen: true);
    adsSliderProviderModel=Provider.of<AdsSliderProviderModel>(context,listen: true);
    if(adsSliderProviderModel!.adsSliderModelList.isEmpty){
    Future.delayed(Duration(milliseconds: 4000)).then((value){
      if(adsSliderProviderModel!.adsSliderModelList.isEmpty){
        adsSliderProviderModel!.getAdsSlider();
      }}
    );}
    return  BaseScreen(
      tag: "MainCategoriesScreen",
      showBottomBar: true,
        showSettings: false,
        showIntro: false,
        body: Container(
          color: C.BASE_ORANGE,
          child:
        Stack(
          fit:StackFit.expand,
          children: [
            Column(children: [
              ActionBarWidget(Constants.currentUser!=null?"${sprintf(tr("hello"),[" ${Constants.currentUser!.name}"])}":"", context,showSetting: true,backgroundColor: C.BASE_ORANGE,textColor: Colors.white,showBack: false,),
              Container(height: MediaQuery.of(context).size.height*0.30,child: AdsSlider(),),
              Expanded(child:CategoryList(context,categoriesProviderModel))
            ],),
            categoriesProviderModel!.showHadeth?_adotionAlert():Container(),
            categoriesProviderModel!.isLoading?LoadingProgress():Container(),

          ],),));
  }
  Widget _adotionAlert(){
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          Container(
            padding: EdgeInsets.all(D.default_10),
            color: C.ADAPTION_COLOR,
            height: utilsProviderModel!.isArabic?D.default_200:D.default_200*1.35,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Directionality(textDirection: TextDirection.rtl,child: Container(
                  margin: EdgeInsets.only(right: D.default_10,top:D.default_10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr("hadeth_start"),style: S.h2(color: Colors.white),),
                      Text(tr("hadeth")+tr("hadeth_end"),style: S.h2(color: Colors.white),),
                    ],),),),),
                InkWell(
                  onTap: (){
                    categoriesProviderModel!.showHadeth=false;
                    categoriesProviderModel!.notifyListeners();
                    MyUtils.navigate(context, AdoptionScreen());
                  },
                  child: Container(child:
                  Row(children: [
                    Checkbox(
                        side: BorderSide(color: Colors.white),
                        checkColor: Colors.white,
                        activeColor: Colors.white,
                        value: true, onChanged: (value){
                      categoriesProviderModel!.showHadeth=false;
                      categoriesProviderModel!.notifyListeners();
                      MyUtils.navigate(context, AdoptionScreen());
                    }),
                    Text(tr("hadeth_check"),style: S.h3(color: Colors.white),)
                  ],),),)
              ],),
          )
        ],),
    );
  }
  void getRegions(){
    Constants.STATES.clear();
    regionsApi.getRegions().then((value) {
      Constants.REGIONS=value.data;
      for(int i=0;i<Constants.REGIONS.length;i++){
        Constants.STATES.addAll( Constants.REGIONS[i].getStates!);
      }
    });

  }
}
