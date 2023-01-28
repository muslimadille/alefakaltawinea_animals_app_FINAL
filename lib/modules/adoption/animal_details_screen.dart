import 'package:alefakaltawinea_animals_app/modules/adoption/provider/adoption_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/action_bar_widget.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/my_widgets/adoption_alert.dart';
import 'data/animal_pager_list_model.dart';

class AnimalDetailsScreen extends StatefulWidget {
  int index;
   AnimalDetailsScreen(this.index);

  @override
  _AnimalDetailsScreenState createState() => _AnimalDetailsScreenState();
}

class _AnimalDetailsScreenState extends State<AnimalDetailsScreen> {
  AdoptionProviderModel? adoptionProviderModel;
  bool showPhone=false;
  void initState() {
    super.initState();
    adoptionProviderModel=Provider.of<AdoptionProviderModel>(context,listen: false);

  }

  @override
  Widget build(BuildContext context) {
    adoptionProviderModel=Provider.of<AdoptionProviderModel>(context,listen: true);
    return BaseScreen(
      showSettings: false,
      showBottomBar: true,
      tag: "AdoptionScreen",
      body: Column(
        children: [
          ActionBarWidget("", context,backgroundColor: C.ADAPTION_COLOR,),
          Expanded(
              child: Container(
                color: C.ADAPTION_COLOR,
                  child: Stack(

                    alignment: AlignmentDirectional.topCenter,
                    children: [
                     _whiteContainer(),
                      Positioned(child:
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(D.default_200)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: Offset(1, 1),
                                  blurRadius: 1,
                                  spreadRadius: 0.5)
                            ]),
                        child: TransitionImage(
                        adoptionProviderModel!.animalPagerListModel!.data![widget.index].photo!,
                        radius: D.default_200,
                        fit: BoxFit.cover,
                        width: D.default_120,
                        height: D.default_120,
                        strokeColor: Colors.white,

                      ),),top:D.default_120)
                    ],
                  )))
        ],
      ),
    );
  }
  Widget _greenCOntainer() {
    return Container(
      margin: EdgeInsets.only(top: D.default_90),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(D.default_80),
              topRight: Radius.circular(D.default_80)),
          color: C.BASE_BLUE,
          ),
      child: Column(
        children: [],
      ),
    );
  }

  Widget _whiteContainer() {
    return Container(
      margin: EdgeInsets.only(top: D.default_180),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(D.default_30),
              topRight: Radius.circular(D.default_30)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(1, 1),
                blurRadius: 1,
                spreadRadius: 0.5)
          ]),
      child: detailsCrd(),
    );
  }
  Widget detailsCrd(){
    AnimalData data=adoptionProviderModel!.animalPagerListModel!.data![widget.index];
    return SingleChildScrollView(child: Container(
      margin: EdgeInsets.only(top:D.default_80,bottom: D.default_20,left: D.default_20,right: D.default_20),
      padding: EdgeInsets.all(D.default_2),

      child: SingleChildScrollView(child: Column(
        children: [
          _infoItem(tr("name"),data.name??".........."),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("age"),data.age!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("gendar"),data.gender!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("type"),data.type!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("vaccation"),data.vaccination!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("city"),data.city!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("reason"),data.reasonToGiveUp!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("status"),data.healthStatus!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("condition"),data.conditions!),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          _infoItem(tr("add_date"),data.createdAt!=null?data.createdAt!.split("T")[0]:"......."),
          Container(color: Colors.grey[400],height: D.default_1,width: double.infinity,),
          InkWell(
            onTap: (){
              MyUtils.basePopup(context, body: AdoptionAlert(onOkPressed: (){
                setState(() {
                  showPhone=true;
                });
              }, content: tr("adoption_alert"),));
            },
            child: _infoItem(tr("contact_phone"),showPhone?(data.phone??".........."):tr("show_phone")),),
        ],
      ),),
    ),);
  }
  Widget _infoItem(String title,String content){
    return Container(
      padding: EdgeInsets.only(left: D.default_10,right: D.default_10,top:D.default_5,bottom: D.default_5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text("${title}:  ",style: S.h2(color: Colors.black54),),
          Expanded(child: Text("${content}",style: S.h2(color: Colors.black54),)),
        ],),);
  }

}
