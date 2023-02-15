
import 'dart:async';

import 'package:alefakaltawinea_animals_app/data/dio/my_rasponce.dart';
import 'package:alefakaltawinea_animals_app/modules/fav/data/fav_api.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/details_screen/service_provider_details_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/getServiceProvidersApi.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ServiceProvidersProviderModel with ChangeNotifier {
  ///.....ui controllers.........
  bool isLoading=false;


  void setIsLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
  Set<Marker> markers = {};
  CameraPosition? currentCameraPosition;
  Completer<GoogleMapController> mapController=Completer();
  List<Data> currentLocationsList=[];
  Data? currentSelectedShop;
  int?selectedMarkerColor;
  bool fetchEnd=true;

  /// ..........categories...........
  ServiceProviderModel? serviceProviderModel;
  ServiceProviderModel? searchServiceProviderModel;
  GetServiceProvidersApi getServiceProvidersApi=GetServiceProvidersApi();
  getServiceProvidersList(int categoryId,int page,{String lat="",String long="",String keyword="",String state_id=""}) async {
    setIsLoading(true);
    if(page==1) {
      serviceProviderModel = null;
    }
    MyResponse<ServiceProviderModel> response =
    await getServiceProvidersApi.getServiceProviders(categoryId, page,keyword: keyword);
    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      ServiceProviderModel model=response.data;
      if(page>1){
        serviceProviderModel!.data!.addAll(model.data!);
        notifyListeners();
      }else{
        setServiceProviderModel(response.data);
      }

      setIsLoading(false);
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();

  }
  getSearchList(int categoryId,int page,{String lat="",String long="",String keyword="",String state_id=""}) async {
    searchServiceProviderModel==null;
    if(page==1) {
      searchServiceProviderModel = null;
    }
    setIsLoading(true);
    MyResponse<ServiceProviderModel> response =
    await getServiceProvidersApi.getSearch(categoryId, page,keyword: keyword);
    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      setSearchModel(response.data);
      setIsLoading(false);
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();

  }

  getClosestList(BuildContext ctx,int categoryId,String lat,String long,int color,bool all) async {
    setIsLoading(true);
    MyResponse<List<Data>> response =
    await getServiceProvidersApi.getClosest(categoryId,lat,long);

    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      currentLocationsList.clear();
      currentLocationsList.addAll(response.data);
      if(currentLocationsList.isNotEmpty){
        //currentSelectedShop=currentLocationsList[0];
      }else{
        currentSelectedShop=null;
        await Fluttertoast.showToast(msg: "عفوا لا يوجد نتائج للعرض");
      }
        setMarkers(response.data,ctx,color,all);
      setIsLoading(false);
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();

  }

  void setServiceProviderModel(ServiceProviderModel value){
    if(serviceProviderModel==null){
      serviceProviderModel=value;
    }else{
      if(value.data!.isNotEmpty){
        for(int i=0;i<value.data!.length;i++){
          for(int n=0;n<serviceProviderModel!.data!.length;n++){
            if(serviceProviderModel!.data![n].id!=value.data![i].id){
              serviceProviderModel!.data!.add(value.data![i]);

            };
          }

        }
      }
    }
    notifyListeners();
  }
  void setSearchModel(ServiceProviderModel value){
      searchServiceProviderModel=value;
    notifyListeners();
  }

  void setMarkers(List<Data> value ,BuildContext ctx,int color,bool all)async{
    setIsLoading(true);
    if(!all){
      markers.clear();
    }
      if(value.isNotEmpty){
        for(int i=0;i<value.length;i++){
          LatLng latlng=LatLng(double.parse(value[i].latitude!), double.parse(value[i].longitude!));
          markers.add(Marker(
            onTap: (){
              currentSelectedShop=currentLocationsList[i];
              selectedMarkerColor=color;
              notifyListeners();
            },
            markerId: MarkerId("${value[i].id}"),
            position: latlng,
            infoWindow: InfoWindow(
              title: "${value[i].name}",
                onTap:(){
                  //MyUtils.navigate(ctx, ServiceProviderDetailsScreen(value[i]));
                }
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(HSLColor.fromColor(Color(color)).hue),

          ));
        }
        currentCameraPosition=CameraPosition(
            bearing: 0.0,
            tilt: 0.0,
            zoom: 9,
            target: LatLng(double.parse(value[0].latitude!), double.parse(value[0].longitude!)));
        final GoogleMapController controller=await mapController.future;

        await controller.animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition!));

      }else{
        markers.clear();

      }
setIsLoading(false);
    notifyListeners();
  }
  ///...................fav.......................................
  FavApi favApi=FavApi();
  List<Data> favList=[];
  setFavList(List<Data> value){
    favList=value;
    notifyListeners();
  }
  getFavsList() async {
    setIsLoading(true);
    MyResponse<List<Data>> response =
    await favApi.getFavs();
    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      setFavList(response.data);
      setIsLoading(false);
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();

  }
  setFav(int shopId) async {
    //setIsLoading(true);
    MyResponse<dynamic> response =
    await favApi.setFav(shopId);
    if (response.status == Apis.CODE_SUCCESS ){
      setIsLoading(false);
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();

  }


}