
import 'package:alefakaltawinea_animals_app/modules/homeTabsScreen/homeTabsScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/homeTabsScreen/provider/intro_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/settings/settings_screen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';




class BaseScreen extends StatefulWidget {
  String tag;
  Widget body;
  bool showSettings;
  bool showBottomBar;
  bool showIntro;
   BaseScreen({required this.body,required this.showSettings,required this.showBottomBar,this.showIntro=false,required this.tag});


  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> with TickerProviderStateMixin{

  IntroProviderModel?introProviderModel;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences? prefs;





  @override
  void initState() {
    super.initState();

     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

  }

  @override
  void dispose() {
    introProviderModel!.intro!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    introProviderModel =Provider.of<IntroProviderModel>(context, listen: true);
    return SafeArea(child: Scaffold(
        key: _scaffoldKey,
        body: Column(children: [
          widget.showSettings?_actionBar():Container(height: 0,),
          Expanded(child: widget.body,),
          widget.showBottomBar?HomeTabsScreen(introProviderModel,introProviderModel!=null&&widget.tag=="MainCategoriesScreen"):Container()
        ],),
      ),);
  }
  Widget _actionBar(){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: C.BASE_BLUE,
          boxShadow:[BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset:Offset(2,2),
              blurRadius:2,
              spreadRadius: 2
          )]
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Center(
            child:
        IconButton(key: introProviderModel!.intro!=null&&widget.tag=="MainCategoriesScreen"?introProviderModel!.intro!.keys[0]:Key("setting_btn"),onPressed: (){
          MyUtils.navigate(context, SettingScreen());
        }, icon: Icon(Icons.menu,color: Colors.white,size: D.default_40)))
        ],),
      ),
    );
  }


}
