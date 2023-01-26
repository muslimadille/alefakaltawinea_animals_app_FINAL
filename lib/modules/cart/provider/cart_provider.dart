import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sprintf/sprintf.dart';
import '../../../data/dio/my_rasponce.dart';
import '../../../utils/my_utils/apis.dart';
import '../../../utils/my_widgets/web_view.dart';
import '../../offers/offer_details/offer_code_model.dart';
import '../add_cart_model.dart';
import '../add_cart_respose_model.dart';
import '../cart_api.dart';
import '../cobon_model.dart';
import '../my_carts_model.dart';


class CartProvider with ChangeNotifier{
  ///.....ui controllers.........
  bool isLoading=false;
  int selectedCategoryIndex=0;
  String offerCode="";
  String cobon="";
  bool showCobonPart=false;
  void setShowCobonPart(bool value){
    showCobonPart=value;
    notifyListeners();
  }
  void setIsLoading(bool value){
    isLoading=value;
    notifyListeners();
  }
  List<MyCart>myCarts=[];
  CartApi cartApi=CartApi();
  addCart(BuildContext ctx,Carts body) async {
    setIsLoading(true);
    MyResponse<AddCartResponseModel> response =
    await cartApi.addCart(body,cobon);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      MyUtils.navigateReplaceCurrent(ctx, WebPage(response.data.url));
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();
  }

  getMyCart({int shop_id=0,int offer_id=0}) async {
    myCarts.clear();
    setIsLoading(true);
    MyResponse<MyCartsModel> response =
    await cartApi.getMyCarts();
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      MyCartsModel data=response.data;
      myCarts.addAll(data.data!);
      if(shop_id>0){
        useCode(shop_id,offer_id,myCarts[0].id!);
      }
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      setIsLoading(false);
    }else{
      setIsLoading(false);
    }
    notifyListeners();
  }
  useCode(int shop_id,int offer_id,int card_id) async {
    setIsLoading(true);
    MyResponse<OfferCodeModel> response =
    await cartApi.useCode(shop_id,offer_id,card_id);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      OfferCodeModel offerCodeModel=response.data;
      offerCode=offerCodeModel.code!;
    }else if(response.status == Apis.CODE_SUCCESS &&response.data==null){
      offerCode="";
      setIsLoading(false);
    }else{
      offerCode="";
      setIsLoading(false);
    }
    notifyListeners();
  }

  checkCobon(BuildContext ctx,String cobone) async {
    cobon="";
    setIsLoading(true);
    MyResponse<CobonModel> response =
    await cartApi.checkCobon(cobone);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      CobonModel cobonModel=response.data;
      cobon=cobonModel.code??"";
      await Fluttertoast.showToast(msg:sprintf(tr("available_code"),[cobonModel.percent]) ??"" );
      setShowCobonPart(false);
    }else if(response.status == Apis.CODE_SHOW_MESSAGE){
      setIsLoading(false);
      setShowCobonPart(false);
      await Fluttertoast.showToast(msg:response.msg??"" );
    }else{
      setIsLoading(false);
      setShowCobonPart(false);
    }
    notifyListeners();
  }
  deleteCard(int card_id) async {
    setIsLoading(true);
    MyResponse<bool> response =
    await cartApi.deleteCarts(card_id);
    if (response.status == Apis.CODE_SUCCESS){
      setIsLoading(false);
      await getMyCart();
      await Fluttertoast.showToast(msg: "${response.msg}");
    }else{
      await Fluttertoast.showToast(msg: "${response.msg}");
      setIsLoading(false);
    }
    notifyListeners();
  }
  editCard(BuildContext context,AddCartModel data) async {
    setIsLoading(true);
    MyResponse<dynamic> response =
    await cartApi.editeCart(model: data);
    if (response.status == Apis.CODE_SHOW_MESSAGE){
      setIsLoading(false);
      await getMyCart();
      await Fluttertoast.showToast(msg: "${response.msg}");
      Navigator.pop(context);
    }else{
      await Fluttertoast.showToast(msg: "${response.msg}");
      setIsLoading(false);
    }
    notifyListeners();
  }

}