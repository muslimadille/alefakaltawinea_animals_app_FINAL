
import 'dart:async';

import 'package:alefakaltawinea_animals_app/data/dio/my_rasponce.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/data/categories_model.dart';
import 'package:alefakaltawinea_animals_app/modules/fav/data/fav_api.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/details_screen/service_provider_details_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/getServiceProvidersApi.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:flutter/Material.dart';
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
  CategoriesDataModel? selectedCategory;


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

  getClosestList(BuildContext ctx,int categoryId,String lat,String long,List<CategoriesDataModel> categoriesList) async {
    setIsLoading(true);
    MyResponse<List<Data>> response =
    await getServiceProvidersApi.getClosest(categoryId,lat,long);

    if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
      if((response.data!as List<Data>).isNotEmpty){
        currentLocationsList.clear();
        currentLocationsList.addAll(response.data);
      }

      currentSelectedShop=null;
      setMarkers(currentLocationsList,categoriesList,ctx,false);
      setIsLoading(false);
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      currentLocationsList.clear();
      currentSelectedShop=null;
      setMarkers(currentLocationsList,categoriesList,ctx,false);
        await Fluttertoast.showToast(msg: "عفوا لا يوجد نتائج للعرض");
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();

  }
  getAllClosestList(BuildContext ctx,String lat,String long,List<CategoriesDataModel> categoriesList) async {
    currentLocationsList.clear();
    currentSelectedShop=null;
    setIsLoading(true);
    for(int i=0;i< categoriesList.length;i++){
      MyResponse<List<Data>> response =
      await getServiceProvidersApi.getClosest(categoriesList[i].id??0,lat,long);
      if (response.status == Apis.CODE_SUCCESS &&response.data!=null){
        currentLocationsList.addAll(response.data);

      }
  }
    setMarkers(currentLocationsList,categoriesList,ctx,true);
    setIsLoading(false);
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

  void setMarkers(List<Data> value ,List<CategoriesDataModel>categories,BuildContext ctx,bool all)async{
    if(!all){
      markers.clear();
    }
      if(value.isNotEmpty){
        for(int i=0;i<value.length;i++){
          CategoriesDataModel? category=categories.where((element) => element.id.toString()==currentLocationsList[i].categoryId).single;
          LatLng latlng=LatLng(double.parse(value[i].latitude!), double.parse(value[i].longitude!));
          markers.add(Marker(
            onTap: (){
              selectedCategory=category;
              currentSelectedShop=currentLocationsList[i];
              notifyListeners();
            },
            markerId: MarkerId("${value[i].id}"),
            position: latlng,
            icon: BitmapDescriptor.defaultMarkerWithHue(HSLColor.fromColor(Color(int.parse(category.color!.replaceAll("#", "0xff")))).hue),

          ));
        }
        currentCameraPosition=CameraPosition(
            bearing: 0.0,
            tilt: 0.0,
            zoom: 14,
            target: LatLng(double.parse(value[0].latitude!), double.parse(value[0].longitude!)));
        final GoogleMapController controller=await mapController.future;

        await controller.animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition!));

      }else{}
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