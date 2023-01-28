import 'dart:async';

import 'package:alefakaltawinea_animals_app/modules/cart/add_cart_model.dart';
import 'package:alefakaltawinea_animals_app/modules/cart/provider/cart_provider.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../modules/cart/cart_api.dart';
import '../../modules/cart/my_carts_model.dart';
import '../../utils/my_utils/baseDimentions.dart';
import '../../utils/my_utils/myColors.dart';
import '../../utils/my_utils/resources.dart';
import '../../utils/my_widgets/transition_image.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class EditeCartScreen extends StatefulWidget {
  final MyCart myCart;

  const EditeCartScreen({required this.myCart, Key? key}) : super(key: key);

  @override
  _EditeCartScreenState createState() => _EditeCartScreenState();
}

class _EditeCartScreenState extends State<EditeCartScreen> {
  bool imageValid = true;
  List<Widget> items = [];
  TextEditingController _bitNameControllers = TextEditingController();
  TextEditingController _cityControllers = TextEditingController();
  TextEditingController _familyControllers = TextEditingController();
  TextEditingController _dateOfBirthControllers = TextEditingController();

  String _selectedGenders = "";
  List<String> _genders = [tr("male"), tr("female"), tr("Did_not_matter")];
  String _selectedTypes = "";
  List<String> _types = [
    tr("Dog"),
    tr("cat"),
    tr("bird"),
    tr("reptile"),
    tr("rabbit"),
    tr("Hamster"),
    tr("fish"),
    tr("livestock"),
    tr("camel"),
    tr("Horse"),
    tr("turtle"),
    tr("turtle"),
    tr("other")
  ];
  String _uploadedImages = "";
  dynamic _imagesFiles;

  CartApi cartApi = CartApi();
  CartProvider? cartProvider;

  bool isKeboardopened = false;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    _bitNameControllers.text = widget.myCart.name ?? '';
    _selectedTypes = widget.myCart.kind ?? "";
    _familyControllers.text = widget.myCart.family ?? "";
    _selectedGenders = widget.myCart.gender ?? "";
    _uploadedImages = widget.myCart.photo ?? "";
    _cityControllers.text = widget.myCart.country ?? "";
    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {
        isKeboardopened = visible;
      });
    });
    cartProvider = Provider.of<CartProvider>(context, listen: false);
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context, listen: true);
    return _dataItem();
  }

  Widget _dataItem() {
    return Container(
        padding: EdgeInsets.all(D.default_20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
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
            _addImagePart(),
            Row(
              children: [
                Expanded(child: _bitName()),
                SizedBox(
                  width: D.default_10,
                ),
                //Expanded(child: _bitDate()),
              ],
            ),
            Row(
              children: [

                Expanded(child: _bitCity()),
                SizedBox(
                  width: D.default_20,
                ),
                Expanded(child: _bitFamily()),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Container(
                  child: Row(
                    children: [
                      Text(
                        tr("gendar") + ":",
                        style: S.h2(color: Colors.grey),
                      ),
                      _genderSpinner()
                    ],
                  ),
                )),
                SizedBox(
                  width: D.default_20,
                ),
                Expanded(
                    child: Container(
                      child: Row(
                        children: [
                          Text(
                            tr("type") + ":",
                            style: S.h2(color: Colors.grey),
                          ),
                          _typeSpinner()
                        ],
                      ),
                    )),

              ],
            ),
            SizedBox(height: D.default_10,),
            _addCartBtn(),

          ],
        ));
  }

  Widget _addCartBtn() {
    return Center(
      child: Row(children: [
        Expanded(child: _acceptBtn()),
        Expanded(child: _deleteBtn())
      ],),
    );
  }
  Widget _acceptBtn() {
    return InkWell(
      onTap: () async{
        _addCard();
      },
      child: Container(
        margin: EdgeInsets.all(D.default_10),
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
          tr("submit"),
          style: S.h3(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget _deleteBtn() {
    return InkWell(
      onTap: () async{
        Navigator.pop(context);
      },
      child: Container(
        margin: EdgeInsets.all(D.default_10),
        padding: EdgeInsets.only(
            left: D.default_10,
            right: D.default_10,
            top: D.default_10,
            bottom: D.default_10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_15),
            color: Colors.red,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: Text(
          tr("cancel"),
          style: S.h3(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _addImagePart() {
    return InkWell(
        onTap: () {
          _imgFromGallery();
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
            child: _imagesFiles != null
                ? TransitionImage(widget.myCart.photo??Res.DEFAULT_ADD_IMAGE,
                    fit: BoxFit.cover,
                    file: _imagesFiles,
                    radius: D.default_5,
                    width: D.default_130,
                    height: D.default_130,
                    padding: EdgeInsets.all(D.default_10),
                    placeWidget: TransitionImage(
                      Res.DEFAULT_ADD_IMAGE,
                      width: D.default_50,
                      height: D.default_50,
                    ),
                    placeHolderImage: Res.DEFAULT_IMAGE,
                    strokeColor: imageValid ? Colors.white : Colors.red,
                    strokeWidth: D.default_2)
                : TransitionImage(widget.myCart.photo??Res.DEFAULT_ADD_IMAGE,
                fit: BoxFit.cover,
                radius: D.default_5,
                width: D.default_130,
                height: D.default_130,
                padding: EdgeInsets.all(D.default_10),
                placeWidget: TransitionImage(
                  Res.DEFAULT_ADD_IMAGE,
                  width: D.default_50,
                  height: D.default_50,
                ),
                placeHolderImage: Res.DEFAULT_IMAGE,
                strokeColor: imageValid ? Colors.white : Colors.red,
                strokeWidth: D.default_2)));
  }

  _imgFromGallery() async {
    ImagePicker? imagePicker = ImagePicker();
    PickedFile? compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _imagesFiles = File(compressedImage!.path);
      _uploadCartImage();
    });
  }

  void _uploadCartImage() async {
    File image = _imagesFiles as File;
    MultipartFile mFile = await MultipartFile.fromFile(
      image.path,
      filename: image.path.split('/').last,
      contentType:
          MediaType("image", image.path.split('/').last.split(".").last),
    );
    FormData formData = FormData.fromMap({
      "file": mFile,
    });
    await cartApi.uploadCartImage(formData).then((value) {
      setState(() {
        _uploadedImages = value.data.toString();
      });
    });
  }

  Widget _bitName() {
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
              controller: _bitNameControllers,
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

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: firstDate,
        lastDate: lastDate);
    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.year}/${pickedDate.month}/${pickedDate.day}";
      });
    }
  }

  Widget _bitDate() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            _selectDate(context, _dateOfBirthControllers);
          },
          child: Row(
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
                controller: _dateOfBirthControllers,
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
          ),
        ),
        Container(height: D.default_1, color: Colors.grey),
      ],
    );
  }

  Widget _bitFamily() {
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
              controller: _familyControllers,
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

  Widget _bitCity() {
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
              controller: _cityControllers,
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

  Widget _genderSpinner() {
    return Container(
      height: D.default_50,
      margin: EdgeInsets.only(
          left: D.default_5, right: D.default_5, top: D.default_10),
      padding: EdgeInsets.only(left: D.default_10, right: D.default_10),
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
              _selectedGenders,
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
              _selectedGenders = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _typeSpinner() {
    return Container(
      height: D.default_50,
      margin: EdgeInsets.only(
          left: D.default_5, right: D.default_5, top: D.default_10),
      padding: EdgeInsets.only(left: D.default_10, right: D.default_10),
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
              _selectedTypes,
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
              _selectedTypes = value!;
            });
          },
        ),
      ),
    );
  }

  void _addCard() {
    AddCartModel addCartModel = AddCartModel();
    addCartModel.name = _bitNameControllers.text;
    addCartModel.kind = _selectedTypes;
    addCartModel.family = _familyControllers.text;
    addCartModel.gender = _selectedGenders;
    addCartModel.photo = _uploadedImages;
    addCartModel.country = _cityControllers.text;
    cartProvider!.editCard(context,widget.myCart.id??0, addCartModel);
  }
}
