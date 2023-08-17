import 'dart:async';

import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/data/categories_model.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/provider/categories_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/provider/sevice_providers_provicer_model.dart';
import 'package:alefakaltawinea_animals_app/utils/location/location_utils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/laoding_view.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../serviceProviders/details_screen/service_provider_details_screen.dart';

class NearToYouScreen extends StatefulWidget {
  const NearToYouScreen({Key? key}) : super(key: key);

  @override
  _NearToYouScreenState createState() => _NearToYouScreenState();
}

class _NearToYouScreenState extends State<NearToYouScreen> {
  static Position? _position;
  static final CameraPosition _myCameraPosition = CameraPosition(
      bearing: 0.0,
      tilt: 0.0,
      target: LatLng(_position!.latitude, _position!.longitude));

  ServiceProvidersProviderModel? serviceProvidersProviderModel;
  CategoriesProviderModel? categoriesProviderModel;

  @override
  void initState() {
    super.initState();
    serviceProvidersProviderModel =
        Provider.of<ServiceProvidersProviderModel>(context, listen: false);
    categoriesProviderModel =
        Provider.of<CategoriesProviderModel>(context, listen: false);
    //selectedCategory = categoriesProviderModel!.categoriesList[0];
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    serviceProvidersProviderModel =
        Provider.of<ServiceProvidersProviderModel>(context, listen: true);
    categoriesProviderModel =
        Provider.of<CategoriesProviderModel>(context, listen: true);
    return BaseScreen(
        showSettings: false,
        showBottomBar: true,
        tag: "",
        body: Stack(
          children: [
            Container(
              child: Center(
                child: _position != null
                    ? Column(
                        children: [
                          Expanded(
                              child: serviceProvidersProviderModel!.isLoading
                                  ? _buildMap()
                                  : _buildMap()),
                          _newTabsContainer()
                        ],
                      )
                    : LoadingProgress(),
              ),
            ),
            serviceProvidersProviderModel!.currentSelectedShop != null
                ? _shopItem()
                : Container(),
            serviceProvidersProviderModel!.isLoading?LoadingProgress():SizedBox()
          ],
        ));
  }

  Future<void> getCurrentLocation() async {
    await LocationUtils.getLocationPermission();
    _position = await Geolocator.getLastKnownPosition().whenComplete(() {
      setState(() {
        _getMyCurrentLocation();
      });
    });
  }

  Widget _buildMap() {
    return GoogleMap(
      minMaxZoomPreference:MinMaxZoomPreference(10, 30),
      initialCameraPosition:
          serviceProvidersProviderModel!.currentCameraPosition != null
              ? serviceProvidersProviderModel!.currentCameraPosition!
              : _myCameraPosition,
      mapType: MapType.normal,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        serviceProvidersProviderModel!.mapController.complete(controller);
      },
      markers: serviceProvidersProviderModel!.markers,
    );
  }

  Future<void> _getMyCurrentLocation() async {
    final GoogleMapController controller =
        await serviceProvidersProviderModel!.mapController.future;
    serviceProvidersProviderModel!.currentCameraPosition=CameraPosition(
        bearing: 0.0,
        tilt: 0.0,
        zoom: 14,
        target: LatLng(_position!.latitude, _position!.longitude));
    await controller.animateCamera(CameraUpdate.newCameraPosition(serviceProvidersProviderModel!.currentCameraPosition!));
      await serviceProvidersProviderModel!.getAllClosestList(
          context,
          _position!.latitude.toString(),
          _position!.longitude.toString(),
          categoriesProviderModel!.categoriesList
      );


  }




  Widget _shopItem() {
    return  serviceProvidersProviderModel!.currentSelectedShop!=null?InkWell(
      onTap: (){
        MyUtils.navigate(context, ServiceProviderDetailsScreen(serviceProvidersProviderModel!.currentSelectedShop!));
      },
      child: Container(
          margin: EdgeInsets.all(D.default_10),
          padding: EdgeInsets.all(D.default_10),
          height: D.default_100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
              border: Border.all(color: Color(serviceProvidersProviderModel!.selectedCategory!=null?int.parse(serviceProvidersProviderModel!.selectedCategory!.color!.replaceAll("#", "0xff")):serviceProvidersProviderModel!.selectedMarkerColor!)),
              color: Colors.white,
              boxShadow:[BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset:Offset(4,4),
                  blurRadius:4,
                  spreadRadius: 2
              )]
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
                  color: Colors.white,
                  border: Border.all(color: Color(serviceProvidersProviderModel!.selectedCategory!=null?int.parse(serviceProvidersProviderModel!.selectedCategory!.color!.replaceAll("#", "0xff")):serviceProvidersProviderModel!.selectedMarkerColor!))
                ),
                margin: EdgeInsets.all(D.default_10),
                child: TransitionImage(
                  "${serviceProvidersProviderModel!.currentSelectedShop!.photo}",
                  fit: BoxFit.cover,
                  radius: D.default_10,
                ),
              ),
              Expanded(
                  child: Text(
                "${serviceProvidersProviderModel!.currentSelectedShop!.name}",
                style: S.h4(color: Color(serviceProvidersProviderModel!.selectedCategory!=null?int.parse(serviceProvidersProviderModel!.selectedCategory!.color!.replaceAll("#", "0xff")):serviceProvidersProviderModel!.selectedMarkerColor!))),
              )
            ],
          )),
    ):Container();
  }
  Widget _newIem(int index) {
    return InkWell(
      onTap: (){
        onItemClick(index);
      },
      child: Container(
      margin: EdgeInsets.all(D.default_10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.default_10),
          color: C.BASE_BLUE,
          boxShadow:[BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset:Offset(1,1),
              blurRadius:1,
              spreadRadius: 1
          )]
      ),
      child: Column(children: [
        Expanded(
            child: TransitionImage(
              getItemImage(index),
              width: double.infinity,
              fit: index==0?BoxFit.contain:BoxFit.contain,
            )),
        Container(
          height: D.default_1,
          color: C.BASE_ORANGE,
          margin: EdgeInsets.only(top:D.default_5),
        ),
        Container(
          height: D.default_30,
          child: Center(
            child: Text(getItemTitle(index),
                style: S.h2(color: Colors.white)),
          ),)],),),);
  }
  String getItemImage(int index){
    switch(index){
      case 0:{
        return "assets/images/logo_new_img.png";
      };
      case 1:{
        return "assets/images/clinics_img.png";
      };
      case 2:{
        return "assets/images/shops_img.png";
      };
      case 3:{
        return "assets/images/home_care-img.png";
      };
      default :{
        return "assets/images/logo_new_img.png";
      };

    }

  }
  String getItemTitle(int index){
    switch(index){
      case 0:{
        return tr("all");
      };
      case 1:{
        return tr("clinic");
      };
      case 2:{
        return tr("shops");
      };
      case 3:{
        return tr("home_care");
      };
      default :{
        return "";
      };

    }

  }
  onItemClick(int index)async{

    if(index>0){

      serviceProvidersProviderModel!.selectedCategory = categoriesProviderModel!.categoriesList[index-1];
        await serviceProvidersProviderModel!.getClosestList(
            context,
            categoriesProviderModel!.categoriesList[index-1].id!,
            _position!.latitude.toString(),
            _position!.longitude.toString(),
          categoriesProviderModel!.categoriesList,
        );
    }else{
      serviceProvidersProviderModel!.markers.clear();
      await serviceProvidersProviderModel!.getAllClosestList(
            context,
            _position!.latitude.toString(),
            _position!.longitude.toString(),
             categoriesProviderModel!.categoriesList
        );
    }

  }
  Widget _newTabsContainer(){
    return Container(
      color: Colors.white.withOpacity(0.90),
      height: D.size(110),
      child: Column(children: [
      Expanded(child: Row(children: [
        Expanded(child: _newIem(0)),
        Expanded(child: _newIem(1),)
      ],),),
      Expanded(child: Row(children: [
        Expanded(child: _newIem(2),),
        Expanded(child: _newIem(3),)
      ],),),

    ]),);
  }
}
