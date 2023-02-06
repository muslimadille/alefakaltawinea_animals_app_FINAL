import 'package:alefakaltawinea_animals_app/modules/cart/my_carts_model.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';

import '../my_utils/constants.dart';
import '../my_utils/myColors.dart';

class AnimalCartWidget extends StatefulWidget {
  MyCart cart;
  bool enableEdite;
  Function? onDelete;
  Function? onEdite;
  AnimalCartWidget({required this.cart,this.enableEdite=false,this.onDelete,this.onEdite,Key? key}) : super(key: key);

  @override
  State<AnimalCartWidget> createState() => _AnimalCartWidgetState();
}

class _AnimalCartWidgetState extends State<AnimalCartWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(children:[
      _buttons(),
      _cartItem()
    ]);
  }
  Widget _buttons(){
    return Container(
      padding: EdgeInsets.only(left: D.default_10,right: D.default_10),
        width: D.size(180),
        child:Row(children: [
      //widget.enableEdite?_deleteBtn():Container(),

      widget.enableEdite?_EditeBtn():Container(),
          Expanded(child: Container()),
    ],));
  }
  Widget _cartItem() {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
            padding: EdgeInsets.only(left: D.size(2), right: D.size(2)),
            margin: EdgeInsets.only(
                top: D.size(4), left: D.size(4), right: D.size(4)),
            width: D.size(180),
            height: D.size(104),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bit_card_bg.png")),
              borderRadius: BorderRadius.circular(D.default_10),
            ),
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: D.size(180),
                  height: D.size(104),
                  child: Column(
                    children: [
                      ///black banner
                      Container(
                        height: D.default_40,
                        margin: EdgeInsets.only(top: D.default_7),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "PET IDENTIFICATION هوية الحيوان الأليف",
                            style: S.h3(color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: D.default_10,
                                left: D.default_20,
                                right: D.default_20,
                                top: D.default_10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(children: [
                                  Expanded(
                                      flex:3,
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: D.default_20, bottom: D.default_10),
                                        child: TransitionImage(
                                          (widget.cart.photo ?? "").isNotEmpty?widget.cart.photo ?? "":"assets/images/adoption_img.png",
                                          width: D.default_80,
                                          fit: BoxFit.cover,
                                          strokeColor: Colors.black,
                                          strokeWidth: D.default_2,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        margin: EdgeInsets.only(bottom: D.default_15),
                                        child: TransitionImage("assets/images/cart_logo.png",
                                          height: D.default_70,
                                          width: D.default_70,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      )),
                                ],),
                                SizedBox(width: D.default_10,),
                                ///content
                                Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          cartDataItem("Name of pet", "اسم الأليف",
                                              widget.cart.name ?? ""),
                                          cartDataItem(
                                              "Address",
                                              "البلد",
                                              widget.cart.country ??
                                                  ""),
                                          cartDataItem(
                                              "Breed",
                                              "الفصيلة",
                                              widget.cart.family ??
                                                  ""),
                                          cartDataItem(
                                              "Gender",
                                              "الجنس",
                                              widget.cart.gender ??
                                                  ""),
                                          cartDataItem("owner name", "اسم المربي",
                                              Constants.currentUser!.name ?? ""),
                                          cartDataItem(
                                              "Expiration date",
                                              "انتهاء البطاقة",
                                              widget.cart.expiration_at ??
                                                  "")
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ],
            )));
  }
  Widget _deleteBtn(){
    return Container(
      height: D.default_40,
      width: D.default_40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.default_10),
          color: Colors.white,
          boxShadow:[BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset:Offset(1,1),
              blurRadius:1,
              spreadRadius: 1
          )]
      ),
      child: InkWell(
        onTap: (){
          widget.onDelete==null?(){}:widget.onDelete!();
        },
      child: Icon(Icons.delete_forever,color: Colors.red,size: D.default_25,),
    ),);
  }
  Widget _EditeBtn(){
    return Container(
      height: D.default_40,
      width: D.default_40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.default_100),
          color: Colors.black,
          boxShadow:[BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              offset:Offset(1,1),
              blurRadius:1,
              spreadRadius: 1
          )]
      ),
      child: InkWell(
        onTap: (){
          widget.onEdite==null?(){}:widget.onEdite!();
        },
        child: Icon(Icons.edit,color: Colors.white,size: D.default_25,),
      ),);
  }

  Widget cartDataItem(String nameEn, String nameAr, String value) {
    return Container(
      margin: EdgeInsets.only(left: D.default_5, right: D.default_8),
      child: Row(
        children: [
          Text(
            nameEn,
            style: S.h3(color: Colors.black),
            textAlign: TextAlign.start,
          ),
          Expanded(
              child: Text(
                deleteSpaces(value),
                style: S.h3(color: Colors.black),
                textAlign: TextAlign.center,
              )),
          Text(
            nameAr,
            style: S.h3(color: Colors.black),
            textAlign: TextAlign.end,
          )
        ],
      ),
    );
  }
  String deleteSpaces(String value){
    value.replaceAll("  ","");
    return value;
  }

}
