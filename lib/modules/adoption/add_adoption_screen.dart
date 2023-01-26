
import 'dart:convert';

import 'package:alefakaltawinea_animals_app/modules/adoption/data/animal_pager_list_model.dart';
import 'package:alefakaltawinea_animals_app/modules/adoption/provider/adoption_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/apis.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/input%20_validation_mixing.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/resources.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/action_bar_widget.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/laoding_view.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/transition_image.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import '../../utils/my_utils/myUtils.dart';
import '../settings/regions_dialog_widget.dart';
import 'delet_animal_popup.dart';


class AddAdoptionScreen extends StatefulWidget {
  AnimalData?data;
   AddAdoptionScreen({this.data});

  @override
  _AddAdoptionScreenState createState() => _AddAdoptionScreenState();
}

class _AddAdoptionScreenState extends State<AddAdoptionScreen> with InputValidationMixin{
  AdoptionProviderModel? adoptionProviderModel;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _vaccitionController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  TextEditingController _conditionsController = TextEditingController();
  List<String> _genders = [tr("male"), tr("female"),tr("Did_not_matter")];
  String _selectedGenders ="";
  List<String> _vacationStats = [tr("yes"), tr("no")];
  String _selectedVacationStats ="";
  String _selectedCity="";
  final _registerFormGlobalKey = GlobalKey<FormState>();
  File? _cLassImage = null;
  bool imageValid=true;
  var imageFile;
  String selectedCity="";

  void initState() {
    super.initState();
    _getCitiesNameList();
    selectedCity=Constants.currentUser!.stateName??"";
    _selectedGenders=_genders[0];
    _selectedVacationStats=_vacationStats[0];
    _selectedCity=Constants.currentUser!.regionName??widget.data!.city??_citiesList[0];
    adoptionProviderModel=Provider.of<AdoptionProviderModel>(context,listen: false);
    if(widget.data!=null){
       _nameController.text = widget.data!.name??"";
       _phoneController.text = Constants.currentUser!.phone??"";
       _ageController.text = widget.data!.age??"";
       _genderController.text =widget.data!.gender??"" ;
       _typeController.text =widget.data!.type??"" ;
       _vaccitionController.text =widget.data!.vaccination??"";
       _cityController.text =widget.data!.city??"" ;
       _reasonController.text = widget.data!.reasonToGiveUp??"";
       _statusController.text = widget.data!.healthStatus??"";
       _conditionsController.text = widget.data!.conditions??"";
    }


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
              child: adoptionProviderModel!.isLoading?LoadingProgress():Container(
                  color: C.ADAPTION_COLOR,
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: [
                      _whiteContainer(),
                      Positioned(child:
                      Container(
                        width: D.default_130,
                        height: D.default_130,
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
                        child: InkWell(
                            onTap: () {
                              _imgFromGallery();
                            },
                            child: _cLassImage!=null?TransitionImage(
                                widget.data!=null?widget.data!.photo!:Res.DEFAULT_ADD_IMAGE,
                                fit: BoxFit.cover,
                                file:_cLassImage,
                                radius: D.default_200,
                                width: D.default_130,
                                height: D.default_130,
                                padding: EdgeInsets.all(D.default_10),
                                placeHolderImage: Res.DEFAULT_IMAGE,
                                strokeColor: imageValid?Colors.white:Colors.red,
                                strokeWidth: D.default_2):widget.data!=null?TransitionImage(
                                widget.data!.photo!,
                                fit: BoxFit.cover,
                                radius: D.default_200,
                                width: D.default_130,
                                height: D.default_130,
                                padding: EdgeInsets.all(D.default_10),
                                placeHolderImage: Res.DEFAULT_IMAGE,
                                strokeColor: imageValid?Colors.white:Colors.red,
                                strokeWidth: D.default_2):Center(child: Icon(Icons.camera_alt_outlined,size: D.default_50,color: C.ADAPTION_COLOR,),)),),top:D.default_100),
                      Positioned(child: Text(widget.data!=null?tr("edit_adoption_title"):tr("add_adoption_title"),style: S.h2(color: Colors.white),),top: D.default_30,)
                    ],
                  )))
        ],
      ),
    );
  }

  Widget _whiteContainer() {
    return Container(
      margin: EdgeInsets.only(top: D.default_180),
      padding: EdgeInsets.only(top: D.default_10,bottom: D.default_10,left: D.default_20,right:D.default_20),

      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(D.default_80),
              topRight: Radius.circular(D.default_80)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset: Offset(1, 1),
                blurRadius: 1,
                spreadRadius: 0.5)
          ]),
      child: Column(children: [
        Expanded(child: _dataForm()),
        widget.data!=null?
            Container(child:Row(children: [
              Expanded(child: _editBtn()),
              SizedBox(width:D.default_20),
              Expanded(child: _deleteBtn()),
            ],))
            :_addBtn()
      ],),
    );
  }
  Widget _dataForm(){
    return SingleChildScrollView(child: Form(
      key: _registerFormGlobalKey,
      child: Container(
        margin: EdgeInsets.only(left: D.default_20,right: D.default_20,top: D.default_50,bottom: D.default_10),
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _name(),
          _phone(),
          _age(),
          _gender(),
          _type(),
          _vacation(),
          _city(),
          _reason(),
          _status(),
          _conditions(),

        ],
      ),),
    ),);
  }
  Widget _name() {
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _nameController,
          validator: (name) {
            if (isFieldNotEmpty(name!)) {
              return null;
            } else {
              return tr("");
            }
          },
          decoration: InputDecoration(
            labelText: tr("animal_name"),
            labelStyle: S.h4(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.ADAPTION_COLOR),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.ADAPTION_COLOR)),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.ADAPTION_COLOR,
          autofocus: false,
        ));
  }
  Widget _phone() {
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _phoneController,
          validator: (name) {
            if (isFieldNotEmpty(name!)) {
              return null;
            } else {
              return tr("");
            }
          },
          decoration: InputDecoration(
            labelText: tr("contact_phone"),
            labelStyle: S.h4(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.ADAPTION_COLOR),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.ADAPTION_COLOR)),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.phone,
          obscureText: false,
          cursorColor: C.ADAPTION_COLOR,
          autofocus: false,
        ));
  }

  Widget _age() {
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _ageController,
          validator: (name) {
            if (isFieldNotEmpty(name!)) {
              return null;
            } else {
              return tr("");
            }
          },
          decoration: InputDecoration(
            labelText: tr("age"),
            labelStyle: S.h4(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.ADAPTION_COLOR),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.ADAPTION_COLOR)),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.number,
          obscureText: false,
          cursorColor: C.ADAPTION_COLOR,
          autofocus: false,
        ));
  }
  Widget _gender() {
    return Container(
        width: double.infinity,
        child: Column(children: [
          Container(child: Row(children: [
            Text(tr("gendar"),style: S.h4(color: Colors.grey),),
            _genderSpinner(0)],),margin: EdgeInsets.only(left: D.default_20,right: D.default_20),),
          Container(width: MediaQuery.of(context).size.width,height: D.default_1,color: Colors.grey,)
        ],));
  }
  Widget _type() {
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _typeController,
          validator: (name) {
            if (isFieldNotEmpty(name!)) {
              return null;
            } else {
              return tr("");
            }
          },
          decoration: InputDecoration(
            labelText: tr("type"),
            labelStyle: S.h4(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.ADAPTION_COLOR),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.ADAPTION_COLOR)),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.ADAPTION_COLOR,
          autofocus: false,
        ));
  }
  Widget _vacation() {
    return Container(
        width: double.infinity,
        child: Column(children: [
          Container(child: Row(children: [
            Text(tr("vaccation"),style: S.h4(color: Colors.grey),),
            _vacationsSpinner(0)],),margin: EdgeInsets.only(left: D.default_20,right: D.default_20),),
          Container(width: MediaQuery.of(context).size.width,height: D.default_1,color: Colors.grey,)
        ],));
  }
  Widget _city() {
    return InkWell(
      onTap: (){
        MyUtils.basePopup(context, body: RegionsDialogWidget(onItemSelect: (state ) {
          setState(() {
            selectedCity=state.name??"";
                  });
        },) );
      },
      child: Container(
        width: double.infinity,
        child: Column(children: [
          Container(child: Row(children: [
            Text(tr("city"),style: S.h4(color: Colors.grey),),
            SizedBox(width: D.default_20,),
            Text(selectedCity,style: S.h4(color: Colors.grey),),
          ],),margin: EdgeInsets.all(D.default_20),),
          Container(width: MediaQuery.of(context).size.width,height: D.default_1,color: Colors.grey,)
        ],)),);
  }
  Widget _reason() {
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _reasonController,
          validator: (name) {
            if (isFieldNotEmpty(name!)) {
              return null;
            } else {
              return tr("");
            }
          },
          decoration: InputDecoration(
            labelText: tr("reason"),
            labelStyle: S.h4(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.ADAPTION_COLOR),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.ADAPTION_COLOR)),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.ADAPTION_COLOR,
          autofocus: false,
        ));
  }
  Widget _status() {
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _statusController,
          validator: (name) {
            if (isFieldNotEmpty(name!)) {
              return null;
            } else {
              return tr("");
            }
          },
          decoration: InputDecoration(
            labelText: tr("status"),
            labelStyle: S.h4(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.ADAPTION_COLOR),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.ADAPTION_COLOR)),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.ADAPTION_COLOR,
          autofocus: false,
        ));
  }
  Widget _conditions() {
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _conditionsController,
          validator: (name) {
            if (isFieldNotEmpty(name!)) {
              return null;
            } else {
              return tr("");
            }
          },
          decoration: InputDecoration(
            labelText: tr("condition"),
            labelStyle: S.h4(color: Colors.grey),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.ADAPTION_COLOR),
            ),
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.ADAPTION_COLOR)),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.ADAPTION_COLOR,
          autofocus: false,
        ));
  }

  _imgFromGallery() async {
    ImagePicker? imagePicker = ImagePicker();
    PickedFile? compressedImage = await imagePicker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    setState(() {
      _cLassImage = File(compressedImage!.path);

    });
    String fileName = _cLassImage!.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file":
      await MultipartFile.fromFile(_cLassImage!.path, filename:fileName),
    });
    imageFile=formData;
    _cLassImage!.length().then((value) => print("image size ${value}"));
  }

Widget _addBtn(){
    return InkWell(onTap: () async {
      if(_cLassImage!=null&&!adoptionProviderModel!.isLoading){
        if (_registerFormGlobalKey.currentState!.validate()) {
          _registerFormGlobalKey.currentState!.save();
          MultipartFile mFile = await MultipartFile.fromFile(
            _cLassImage!.path, filename:  _cLassImage!.path.split('/').last,
            contentType: MediaType("image",  _cLassImage!.path.split('/').last.split(".").last),);
          FormData formData =  FormData.fromMap({
            "name":_nameController.text,
            "phone":_phoneController.text,
            "category_id":adoptionProviderModel!.categoriesList[adoptionProviderModel!.selectedCategoryIndex].id,
            "age":_ageController.text,
            "type":_typeController.text,
            "gender":_selectedGenders,
            "vaccination":_selectedVacationStats,
            "city":selectedCity,
            "reason_to_give_up":_reasonController.text,
            "health_status":_statusController.text,
            "conditions":_conditionsController.text,
            "photo": mFile,
          });
          adoptionProviderModel!.setAnimal(context,formData,adoptionProviderModel!.categoriesList[adoptionProviderModel!.selectedCategoryIndex].id!);
        }
      }else{
        setState(() {
          imageValid=false;
        });
      }

    },child: Container(
        width: D.default_200,
        margin: EdgeInsets.all(D.default_20),
        padding: EdgeInsets.all(D.default_10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_15),
            color: C.ADAPTION_COLOR,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: Center(
          child: Text(
            tr("add_adoption"),
            style: S.h3(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )),);
}
  Widget _editBtn(){
    return InkWell(onTap: () async {

        if (_registerFormGlobalKey.currentState!.validate()) {
          _registerFormGlobalKey.currentState!.save();
          MultipartFile? mFile;
          if(_cLassImage!=null){
             mFile = await MultipartFile.fromFile(
              _cLassImage!.path, filename:  _cLassImage!.path.split('/').last,
              contentType: MediaType("image",  _cLassImage!.path.split('/').last.split(".").last),);
          }
          FormData formData =  FormData.fromMap({
            "name":_nameController.text,
            "phone":_phoneController.text,
            "category_id":adoptionProviderModel!.categoriesList[adoptionProviderModel!.selectedCategoryIndex].id,
            "age":_ageController.text,
            "type":_typeController.text,
            "gender":_selectedGenders,
            "vaccination":_selectedVacationStats,
            "city":selectedCity,
            "reason_to_give_up":_reasonController.text,
            "health_status":_statusController.text,
            "conditions":_conditionsController.text,
            "photo": mFile,
          });
          adoptionProviderModel!.editAnimal(context,formData,widget.data!.id!);
        }


    },child: Container(
        width: D.default_200,
        margin: EdgeInsets.all(D.default_20),
        padding: EdgeInsets.all(D.default_10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_15),
            color: C.ADAPTION_COLOR,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: Center(
          child: Text(
            tr("edit_adoption"),
            style: S.h3(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )),);
  }
  Widget _deleteBtn(){
    return InkWell(onTap: () async {
      MyUtils.basePopup(context,body: DeletAnimalPopupScreen(title:tr("delete_animal_msg"), onAccept:(){
        adoptionProviderModel!.deleteAnimal(context,widget.data!.id!);
        Navigator.pop(context);
      },));
    },child: Container(
        width: D.default_200,
        margin: EdgeInsets.all(D.default_20),
        padding: EdgeInsets.all(D.default_10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_15),
            color: C.ADAPTION_COLOR,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1)
            ]),
        child: Center(
          child: Text(
            tr("delete_adoption"),
            style: S.h3(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        )),);
  }
  Widget _genderSpinner(int index) {
    return Container(
      height: D.default_50,
      width: D.default_180,
      margin: EdgeInsets.only(
          left: D.default_5, right: D.default_5, top: D.default_10),
      padding: EdgeInsets.only(left: D.default_20, right: D.default_20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(D.default_5),
          ),
      child: Center(
        child: DropdownButton<String>(
          underline: Container(),
          menuMaxHeight: D.default_200,
          borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
          style: TextStyle(color: Colors.blue),
          hint: Container(
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
              _selectedGenders= value!;
            });
          },
        ),
      ),
    );
  }
  Widget _vacationsSpinner(int index) {
    return Container(
      height: D.default_50,
      margin: EdgeInsets.only(
          left: D.default_5, right: D.default_5, top: D.default_10),
      padding: EdgeInsets.only(left: D.default_20, right: D.default_20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(D.default_5),
      ),
      child: Center(
        child: DropdownButton<String>(
          underline: Container(),
          menuMaxHeight: D.default_200,
          borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
          style: TextStyle(color: Colors.blue),
          hint: Container(
            margin: EdgeInsets.all(D.default_10),
            child: Text(
              _selectedVacationStats,
              style: S.h2(color: Colors.grey),
            ),
          ),
          isExpanded: false,
          items: _vacationStats.map((String value) {
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
              _selectedVacationStats = value!;
            });
          },
        ),
      ),
    );
  }
  Widget _citySpinner() {
    return Container(
      height: D.default_50,
      margin: EdgeInsets.only(
          left: D.default_5, right: D.default_5, top: D.default_10),
      padding: EdgeInsets.only(left: D.default_20, right: D.default_20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(D.default_5),
      ),
      child: Center(
        child: DropdownButton<String>(
          underline: Container(),
          menuMaxHeight: D.default_200,
          borderRadius: BorderRadius.all(Radius.circular(D.default_10)),
          style: TextStyle(color: Colors.blue),
          hint: Container(
            margin: EdgeInsets.all(D.default_10),
            child: Text(
              _selectedCity,
              style: S.h2(color: Colors.grey),
            ),
          ),
          isExpanded: false,
          items: _citiesList.map((String value) {
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
              _selectedCity = value!;
            });
          },
        ),
      ),
    );
  }
  List<String>_citiesList=[];
  _getCitiesNameList(){
    for(int i=0;i<Constants.STATES.length;i++){
      _citiesList.add(Constants.STATES[i].name??"");
    }
    setState(() {
      _selectedCity=_citiesList[0];
    });
  }


}
