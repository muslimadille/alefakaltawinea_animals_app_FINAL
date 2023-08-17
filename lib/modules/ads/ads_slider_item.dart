
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/details_screen/service_provider_details_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/my_utils/constants.dart';
import '../cart/add_cart_screen.dart';
import '../profile/no_profile_screen.dart';
import '../registeration/registration_screen.dart';

class AdsSliderItem extends StatefulWidget {
  Data AdsItem;
   AdsSliderItem(this.AdsItem) : super();

  @override
  _AdsSliderItemState createState() => _AdsSliderItemState();
}

class _AdsSliderItemState extends State<AdsSliderItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
      },
      child: Stack(
        alignment:AlignmentDirectional.bottomCenter ,
        children: [
        Container(
        margin: EdgeInsets.only(left: D.default_10,right: D.default_10),
        width: double.infinity,

        child:Column(children: [
          Expanded(child:
          InkWell(
            onTap: ()async{
              switch(widget.AdsItem.type_id){
                case "0":{
                  MyUtils.navigate(context, ServiceProviderDetailsScreen(widget.AdsItem));
                }
                  break;
                case "1":{
                  if((widget.AdsItem.url??"").isNotEmpty){
                    _launchURLBrowser(widget.AdsItem.url??"");
                  }else{
                    if(Constants.currentUser!=null){
                      if(Constants.APPLE_PAY_STATE){
                        MyUtils.navigate(context, AddCartScreen());
                      }else{
                        await Fluttertoast.showToast(msg:tr("Your request has been successfully received") );
                      }
                    }else{
                      MyUtils.navigate(context, RegistrationScreen());
                    }
                  }
                }
                  break;
                case "2":{
                  if((widget.AdsItem.url??"").isNotEmpty){
                    _launchURLBrowser(widget.AdsItem.url??"");
                  }else{
                    if(Constants.currentUser!=null){
                      if(Constants.APPLE_PAY_STATE){
                        MyUtils.navigate(context, AddCartScreen());
                      }else{
                        await Fluttertoast.showToast(msg:tr("Your request has been successfully received") );
                      }
                    }else{
                      MyUtils.navigate(context, RegistrationScreen(fromaddcard: true));
                    }
                  }

                }
                  break;
              }
            },
            child: TransitionImage(
            widget.AdsItem.type_id=="0"?(widget.AdsItem.bannerPhoto??"").contains("https")?widget.AdsItem.bannerPhoto!:"https://alefak.com/uploads/${widget.AdsItem.bannerPhoto}":widget.AdsItem.bannerPhoto??"",
            fit: BoxFit.cover,
            radius:D.default_15,
            width: double.infinity,
              backgroundColor: Colors.white,
          ),)),
          Container(
            height: D.default_40,
            color: C.BASE_ORANGE,
            width: double.infinity,
            padding: EdgeInsets.only(top:D.default_10),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Text(
                  widget.AdsItem.name??""
                  ,style: S.h3(color:Colors.white),textAlign: TextAlign.center,),),
              ],),
          )
        ],),

        ),
      ],),);
  }
  _launchURLBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: tr("cant_opn_url"),backgroundColor: Colors.red,textColor: Colors.white,);
    }
  }
}
