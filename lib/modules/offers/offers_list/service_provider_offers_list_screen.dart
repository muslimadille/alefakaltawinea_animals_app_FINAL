import 'package:alefakaltawinea_animals_app/modules/offers/offer_details/offer_details_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/providers.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceProviderOffersScreen extends StatefulWidget {
  Data serviceProviderData;
  ServiceProviderOffersScreen(this.serviceProviderData);

  @override
  _ServiceProviderOffersScreenState createState() => _ServiceProviderOffersScreenState();
}

class _ServiceProviderOffersScreenState extends State<ServiceProviderOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: D.default_10),
      child: Column(children: [
      Expanded(child:
      widget.serviceProviderData.offers!.isNotEmpty?
      widget.serviceProviderData.categoryId=="4"?_shopsOffersList():
      ListView.separated(
          itemCount: widget.serviceProviderData.offers!.length,
          padding: EdgeInsets.only(top:D.default_10,bottom:D.default_10),
          itemBuilder: (context,index){
            return  MaterialButton(onPressed: (){
              MyUtils.navigate(context, OfferDetailsScreen(widget.serviceProviderData,index));
            },
              padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(left:D.default_15,right:D.default_15,top:D.default_5),
              padding: EdgeInsets.only(left:D.default_10,right:D.default_10,top:D.default_20,bottom:D.default_10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Expanded(child: Container(child: Text(widget.serviceProviderData.offers![index].title!,style: S.h2(color: C.BASE_BLUE),),),),
                    double.parse(widget.serviceProviderData.offers![index]!.price!)>0?Container(
                    margin:EdgeInsets.only(left:D.default_10,right:D.default_10),
                    child: Text("${widget.serviceProviderData.offers![index]!.discountValue!}${tr("curncy")}",style: S.h2(color: C.BASE_BLUE),),):Container()
                ],),
                  double.parse(widget.serviceProviderData.offers![index]!.price!)>0?Text("${tr("init_price")} ${widget.serviceProviderData.offers![index]!.price}${tr("curncy")}-${tr("wafer")}${_getDescoundRaio(index)}%",style: S.h4(color: Colors.grey)):Container(),

                ],),
            ),);
          }, separatorBuilder: (BuildContext context, int index) {
            return Container(margin:EdgeInsets.only(left: D.default_20,right: D.default_20),color: Colors.grey,height: D.default_1,);
      },):_noData())
    ],),);
  }
  Widget _shopsOffersList() {
    return widget.serviceProviderData.offers!.isNotEmpty?Container(
      padding: EdgeInsets.all(D.default_10),
      child: CustomScrollView(slivers: [
        SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: D.default_5,
              mainAxisSpacing: D.default_5,
              childAspectRatio: 1,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.all(D.default_5),
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
                  child: InkWell(
                    onTap: (){
                      if((widget.serviceProviderData.offers![index].url??"")!=""){
                        _launchURLBrowser(widget.serviceProviderData.offers![index].url??"");
                      }
                    },
                    child: TransitionImage(
                      _getImage(index).contains("http")?
                      _getImage(index):
                      "https://alefak.com/uploads/${_getImage(index)}",
                    fit: BoxFit.cover,
                    radius: D.default_10,
                  ),),);
              },
              childCount: widget.serviceProviderData.offers!.length,
              semanticIndexOffset: 1,
            )),
      ]),):_noData();
  }
  String _getImage(int index){
    return context.read<UtilsProviderModel>().isArabic?widget.serviceProviderData.offers![index].photo??'':(widget.serviceProviderData.offers![index].photoEn??'');
  }
  _launchURLBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(msg: tr("cant_opn_url"),backgroundColor: Colors.red,textColor: Colors.white,);
    }
  }

  double _getDescoundRaio(int index){
    double price=double.parse(widget.serviceProviderData.offers![index].price!);
    double discount=double.parse(widget.serviceProviderData.offers![index].discountValue!);
    double raio=((price-discount)/price)*100;
    return raio.toInt().toDouble();

  }
  Widget _noData(){
    return Container(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    TransitionImage(Res.OFFER_ICON,
    width: D.default_60,
        height: D.default_60,
    ),
    SizedBox(height: D.default_20,),
    Text(tr("no_offers"),style: S.h3(color: C.BASE_BLUE),)
    ],),);
  }
}
