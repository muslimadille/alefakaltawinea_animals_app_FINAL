import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/my_utils/baseDimentions.dart';
import '../../utils/my_utils/baseTextStyle.dart';
import '../../utils/my_utils/input _validation_mixing.dart';
import '../../utils/my_utils/myColors.dart';
import 'dart:io' as IO;


class UpdateAppPopup extends StatefulWidget {
  final Function onOkPressed;
  final String content;
  const UpdateAppPopup({required this.content,required this.onOkPressed,Key? key}) : super(key: key);

  @override
  State<UpdateAppPopup> createState() => _UpdateAppPopupState();
}

class _UpdateAppPopupState extends State<UpdateAppPopup> with InputValidationMixin{


  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    widget.onOkPressed();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(D.default_10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.default_10),
          color: Colors.white,
          boxShadow:[BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset:Offset(1,1),
              blurRadius:1,
              spreadRadius: 0.5
          )]
      ),
      child: Stack(
        alignment:AlignmentDirectional.center,
        children: [
          Column(children: [
            SizedBox(height:D.default_50),
            Text(widget.content,style: S.h4(),),
            SizedBox(height:D.default_10),
            Row(children: [
              Expanded(child: _acceptBtn(),)
            ],)

          ],),

        ],),);
  }
  _launchURLBrowser() async {
    final String ure=IO.Platform.isIOS?"https://apps.apple.com/us/app/alefak-%D8%A3%D9%84%D9%8A%D9%81%D9%83-%D8%A7%D9%84%D8%AA%D8%B9%D8%A7%D9%88%D9%86%D9%8A%D8%A9/id1632037683":
    "https://play.google.com/store/apps/details?id=com.alefakeltawinea.alefakaltawinea_animals_app";
    String  url = ure;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: tr("cant_opn_url"),backgroundColor: Colors.red,textColor: Colors.white,);
    }
  }
  Widget _acceptBtn() {
    return InkWell(
      onTap: () async{
        _launchURLBrowser();
      },
      child: Container(
        margin: EdgeInsets.all(D.default_30),
        padding: EdgeInsets.only(
            left: D.default_10,
            right: D.default_10,
            top: D.default_10,
            bottom: D.default_10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_15),
            color: C.BASE_BLUE,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: Text(
          tr("update_btn"),
          style: S.h3(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }



}
