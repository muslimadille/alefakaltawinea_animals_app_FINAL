import 'dart:async';

import 'package:alefakaltawinea_animals_app/modules/cart/provider/cart_provider.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:provider/provider.dart';
import '../../utils/my_utils/baseDimentions.dart';
import '../../utils/my_utils/myColors.dart';
import '../../utils/my_utils/resources.dart';
import '../../utils/my_widgets/action_bar_widget.dart';
import '../../utils/my_widgets/cobon_widget.dart';
import '../../utils/my_widgets/laoding_view.dart';
import '../../utils/my_widgets/transition_image.dart';
import '../baseScreen/baseScreen.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'add_cart_model.dart';
import 'cart_api.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';



class AddCartScreen extends StatefulWidget {
  const AddCartScreen({Key? key}) : super(key: key);

  @override
  _AddCartScreenState createState() => _AddCartScreenState();
}

class _AddCartScreenState extends State<AddCartScreen> {
  bool imageValid = true;
  int _itemsCount = -1;
  List<Widget> items = [];
  List<TextEditingController> _bitNameControllers = [];
  List<TextEditingController> _typeControllers = [];
  List<TextEditingController> _cityControllers = [];
  List<TextEditingController> _familyControllers = [];
  List<TextEditingController> _dateOfBirthControllers = [];

  List<String> _selectedGenders = [];
  List<String> _genders = [tr("male"), tr("female"),tr("Did_not_matter")];
  List<String> _selectedTypes = [];
  List<String> _types = [tr("Dog"), tr("cat"),tr("bird"),tr("reptile"),tr("rabbit"),tr("Hamster"),tr("fish"),tr("livestock"),tr("camel"),tr("Horse"),tr("turtle"),tr("turtle"),tr("other")];
  List<String> _uploadedImages = [];
  List<dynamic>_imagesFiles=[];
  CartApi cartApi=CartApi();
  CartProvider? cartProvider;

  bool isKeboardopened=false;
  late StreamSubscription<bool> keyboardSubscription;



  @override
  void initState() {
    super.initState();
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeboardopened=visible;
      });
    });
    cartProvider=Provider.of<CartProvider>(context,listen: false);
    _addItem();
  }
  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    cartProvider=Provider.of<CartProvider>(context,listen: true);
    return BaseScreen(
      showSettings: false,
      showBottomBar: false,
      tag: "AddCartScreen",
      body: Stack(
        fit:StackFit.expand,
        children: [
        Column(
          children: [
            ActionBarWidget(
                "", context,
                enableShadow:false,
                showSetting:false,
                textColor:Colors.white,
                backgroundColor:C.BASE_BLUE

            ),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.topLeft,
                          stops: [
                            0.1,
                            0.9,
                          ],
                          colors: [
                            C.BASE_BLUE,
                            C.BASE_BLUE,
                          ],
                        )),
                    child: Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        isKeboardopened?Container():_header(),
                        _whiteContainer(),
                      ],
                    )))
          ],
        ),
        cartProvider!.isLoading?LoadingProgress():Container(),
          cartProvider!.showCobonPart?Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(child: InkWell(onTap: (){
                cartProvider!.setShowCobonPart(false);
              },)),
            CobonWidget()
          ],):Container()
      ],),
    );
  }

  Widget _whiteContainer() {
    return Container(
      margin: EdgeInsets.only(top: isKeboardopened?0:D.default_180),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0), topRight: Radius.circular(0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(1, 1),
                blurRadius: 1,
                spreadRadius: 0.5)
          ]),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _dataItem(index);
            },
            itemCount: _bitNameControllers.length,
          )),
          _buttonsPart()
        ],
      ),
    );
  }

  Widget _dataItem(int index) {
    return Container(
        padding: EdgeInsets.all(D.default_20),
        child: Column(
          children: [
            _addImagePart(index),
            Row(children: [
              Expanded(child: _bitName(index)),
              SizedBox(width: D.default_10,),
              Expanded(child: _bitDate(index)),],),
            Row(
              children: [
                Expanded(
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            tr("type")+":",
                            style: S.h2(color: Colors.grey),
                          ),
                          _typeSpinner(index)
                        ],
                      ),
                    )),
                SizedBox(
                  width: D.default_20,
                ),
                Expanded(child: _bitFamily(index)),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  child: Row(
                    children: [
                      Text(
                        tr("gendar")+":",
                        style: S.h2(color: Colors.grey),
                      ),
                      _genderSpinner(index)
                    ],
                  ),
                )),
                SizedBox(
                  width: D.default_20,
                ),
                Expanded(child: _bitCity(index))
              ],
            ),
          ],
        ));
  }

  Widget _buttonsPart() {
    return isKeboardopened?Container():Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            _paymentBtn(),
            _cancelBtn(),],),
          SizedBox(
            height: D.default_10,
          ),
          Text(
            tr("haveApet"),
            style: S.h2(color: C.BASE_BLUE),
            textAlign:TextAlign.center ,
          ),
          _addCartBtn(),
          _cobonBtn(),
          SizedBox(
            height: D.default_20,
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: EdgeInsets.only(top: D.default_40),
      child: Text(
        tr("intro_title"),
        style: S.h1Bold(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _addCartBtn() {
    return Center(
      child: InkWell(
        onTap: () {
          _addItem();
        },
        child: Container(
          width: D.default_100*2.8,
          margin: EdgeInsets.all(D.default_10),
          padding: EdgeInsets.only(
              left: D.default_10,
              right: D.default_10,
              top: D.default_8,
              bottom: D.default_8),
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
            tr("new_cart"),
            style: S.h1Bold(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
  Widget _cobonBtn() {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {
            cartProvider!.setShowCobonPart(true);
          });
        },
        child: Container(
          width: D.default_100*2.8,
          margin: EdgeInsets.all(D.default_10),
          padding: EdgeInsets.only(
              left: D.default_10,
              right: D.default_10,
              top: D.default_8,
              bottom: D.default_8),
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
            tr("cobon_add"),
            style: S.h1Bold(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }


  Widget _paymentBtn() {
    return Center(
      child: InkWell(
        onTap: () {
          _addCard();
          },
        child: Container(
          width: D.default_130,
          margin: EdgeInsets.all(D.default_5),
          padding: EdgeInsets.only(
              left: D.default_10,
              right: D.default_10,
              top: D.default_8,
              bottom: D.default_8),
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
            tr("pay"),
            style: S.h1Bold(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _cancelBtn() {
    return Center(
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: D.default_130,
          margin: EdgeInsets.all(D.default_5),
          padding: EdgeInsets.only(
              left: D.default_10,
              right: D.default_10,
              top: D.default_8,
              bottom: D.default_8),
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
            tr("cancel"),
            style: S.h1Bold(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _addImagePart(int index) {
    return InkWell(
        onTap: () {
          _imgFromGallery(index);
        },
        child: Container(
            width: D.default_130,
            height: D.default_130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(D.default_5)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      offset: Offset(0, 0),
                      blurRadius: 8,
                      spreadRadius: 3)
                ]),
            child: _imagesFiles[index] != null
                ? TransitionImage(Res.DEFAULT_ADD_IMAGE,
                    fit: BoxFit.cover,
                    file: _imagesFiles[index],
                    radius: D.default_5,
                    width: D.default_130,
                    height: D.default_130,
                    padding: EdgeInsets.all(D.default_10),
                    placeWidget: TransitionImage(Res.DEFAULT_ADD_IMAGE,width: D.default_50,height: D.default_50,),
                    placeHolderImage: Res.DEFAULT_IMAGE,
                    strokeColor: imageValid ? Colors.white : Colors.red,
                    strokeWidth: D.default_2)
                : Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: D.default_50,
                      color: Colors.grey[400],
                    ),
                  )));
  }

  _imgFromGallery(int index) async {
    ImagePicker? imagePicker = ImagePicker();
    PickedFile? compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _imagesFiles[index] = File(compressedImage!.path);
      _uploadCartImage(index);
    });
  }
  void _uploadCartImage(int index) async{
    File image=_imagesFiles[index] as File;
    MultipartFile mFile = await MultipartFile.fromFile(
      image.path, filename:  image.path.split('/').last,
      contentType: MediaType("image",  image.path.split('/').last.split(".").last),);
    FormData formData =  FormData.fromMap({
      "file": mFile,
    });
    await cartApi.uploadCartImage(formData).then((value){
      setState((){
        _uploadedImages.add(value.data.toString());
      });
    });
  }

  Widget _bitName(int index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tr("your_pet_name") + ":",
              style: S.h2(color: Colors.grey),
            ),
            Expanded(
                child: Container(
                    child: TextFormField(
                      style: S.h3(),
                      controller: _bitNameControllers[index],
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: C.BASE_BLUE),
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: C.BASE_BLUE)),
                errorStyle: S.h4(color: Colors.red),
                contentPadding: EdgeInsets.all(D.default_5),
              ),
              keyboardType: TextInputType.text,
              obscureText: false,
              cursorColor: C.BASE_BLUE,
              autofocus: false,
            )))
          ],
        ),
        Container(height: D.default_1, color: Colors.grey),
      ],
    );
  }
  Future<void> _selectDate(BuildContext context,TextEditingController controller) async {
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate:DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate);
    if (pickedDate != null ){
      setState(() {
        controller.text="${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
      });
    }

  }
  Widget _bitDate(int index) {
    return Column(
      children: [
        InkWell(onTap: (){
          _selectDate(context,_dateOfBirthControllers[index]);
        },child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tr("date_birth") + ":",
              style: S.h2(color: Colors.grey),
            ),
            Expanded(
                child: Container(
                    child: TextFormField(
                      enabled: false,
                      style: S.h3(),
                      controller: _dateOfBirthControllers[index],
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: C.BASE_BLUE),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: C.BASE_BLUE)),
                        errorStyle: S.h4(color: Colors.red),
                        contentPadding: EdgeInsets.all(D.default_5),
                      ),
                      keyboardType: TextInputType.datetime,
                      obscureText: false,
                      cursorColor: C.BASE_BLUE,
                      autofocus: false,
                    )))
          ],
        ),),
        Container(height: D.default_1, color: Colors.grey),
      ],
    );
  }
  Widget _bitFamily(int index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tr("family") + ":",
              style: S.h2(color: Colors.grey),
            ),
            Expanded(
                child: Container(
                    child: TextFormField(
                      style: S.h3(),
                      controller: _familyControllers[index],
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: C.BASE_BLUE),
                ),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(color: C.BASE_BLUE)),
                errorStyle: S.h4(color: Colors.red),
                contentPadding: EdgeInsets.all(D.default_5),
              ),
              keyboardType: TextInputType.text,
              obscureText: false,
              cursorColor: C.BASE_BLUE,
              autofocus: false,
            )))
          ],
        ),
        Container(height: D.default_1, color: Colors.grey),
      ],
    );
  }
  Widget _bitCity(int index) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tr("bit_country") + ":",
              style: S.h2(color: Colors.grey),
            ),
            Expanded(
                child: Container(
                    child: TextFormField(
                      style: S.h3(),
                      controller: _cityControllers[index],
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: C.BASE_BLUE),
                        ),
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: C.BASE_BLUE)),
                        errorStyle: S.h4(color: Colors.red),
                        contentPadding: EdgeInsets.all(D.default_5),
                      ),
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      cursorColor: C.BASE_BLUE,
                      autofocus: false,
                    )))
          ],
        ),
        Container(height: D.default_1, color: Colors.grey),
      ],
    );
  }





  void _addItem() {
    _itemsCount = _itemsCount + 1;
    _imagesFiles.add(null);
    _selectedGenders.add(_genders[0]);
    _selectedTypes.add(_types[0]);
    _dateOfBirthControllers.add(TextEditingController());
    _familyControllers.add(TextEditingController());
    _bitNameControllers.add(TextEditingController());
    _typeControllers.add(TextEditingController());
    _cityControllers.add(TextEditingController());
    items.add(_dataItem(_itemsCount));
    setState(() {});
  }

  Widget _genderSpinner(int index) {
    return Container(
      height: D.default_50,
      margin: EdgeInsets.only(
          left: D.default_5, right: D.default_5, top: D.default_10),
      padding: EdgeInsets.only(left: D.default_20, right: D.default_20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.default_5),
          border: Border.all(color: Colors.grey)),
      child: Center(
        child: DropdownButton<String>(
          underline: Container(),
          menuMaxHeight: D.default_200,
          borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
          style: TextStyle(color: Colors.blue),
          hint: Container(
            margin: EdgeInsets.all(D.default_10),
            child: Text(
              _selectedGenders[index],
              style: S.h2(color: Colors.grey),
            ),
          ),
          isExpanded: false,
          items: _genders.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                child: Text(
                  value,
                  style: S.h4(color: Colors.grey),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGenders[index] = value!;
            });
          },
        ),
      ),
    );
  }
  Widget _typeSpinner(int index) {
    return Container(
      height: D.default_50,
      margin: EdgeInsets.only(
          left: D.default_5, right: D.default_5, top: D.default_10),
      padding: EdgeInsets.only(left: D.default_20, right: D.default_20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.default_5),
          border: Border.all(color: Colors.grey)),
      child: Center(
        child: DropdownButton<String>(
          underline: Container(),
          menuMaxHeight: D.default_200,
          borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
          style: TextStyle(color: Colors.blue),
          hint: Container(
            margin: EdgeInsets.all(D.default_10),
            child: Text(
              _selectedTypes[index],
              style: S.h2(color: Colors.grey),
            ),
          ),
          isExpanded: false,
          items: _types.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                child: Text(
                  value,
                  style: S.h4(color: Colors.grey),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTypes[index] = value!;
            });
          },
        ),
      ),
    );
  }
  void _addCard(){
    Carts cartsDatas=Carts();
    List<AddCartModel>cartsList=[];
    for(int i=0;i<_bitNameControllers.length;i++){
      AddCartModel addCartModel=AddCartModel();
      addCartModel.name=_bitNameControllers[i].text;
      addCartModel.kind=_selectedTypes[i];
      addCartModel.family=_familyControllers[i].text;
      addCartModel.gender=_selectedGenders[i];
      addCartModel.photo=_uploadedImages.isNotEmpty?_uploadedImages[i]:"";
      addCartModel.country=_cityControllers[i].text;
      cartsList.add(addCartModel);
    }
    cartsDatas.cards=cartsList;
    cartsDatas.version="v2";
    cartProvider!.addCart(context, cartsDatas);
  }


  static void showBottomSheet(BuildContext context,Widget body,double height){
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor:Colors.transparent,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(D.default_20),topRight:Radius.circular(D.default_20)),
            color: Colors.white,
          ),
          child: body,

        ),
      ),
    );
  }

}
