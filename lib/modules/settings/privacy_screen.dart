import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
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
import 'package:webview_flutter/webview_flutter.dart';



class PrivacyScreen extends StatefulWidget {
  bool hideButtomBar;
  PrivacyScreen({this.hideButtomBar=false,Key? key}) : super(key: key);

  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      BaseScreen(
        showSettings: false,
        showBottomBar: !widget.hideButtomBar,
        tag: "PrivacyScreen",
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActionBarWidget(tr("Privacy_screen_title"), context,showSetting: !widget.hideButtomBar,),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(D.default_20),
                  child: WebView(initialUrl: Constants.APP_INFO!.privacy,

                  ),),
              )
            ],
          ),
        ),
      ),
    ],);
  }

}
