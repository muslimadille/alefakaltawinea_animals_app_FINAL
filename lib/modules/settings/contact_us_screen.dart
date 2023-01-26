import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/login/provider/user_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/otp/phone_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/settings/provider/settings_provider.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/input%20_validation_mixing.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/laoding_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../utils/my_widgets/action_bar_widget.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> with  InputValidationMixin{
  TextEditingController _phoneController=TextEditingController();
  TextEditingController _nameController=TextEditingController();
  TextEditingController _problimController=TextEditingController();
  TextEditingController _timeController=TextEditingController();
  bool isLoading=false;
  final _loginFormGlobalKey = GlobalKey < FormState > ();
  SettingsProvider? settingsProvider;
  @override
  void initState() {
    super.initState();
    settingsProvider=Provider.of<SettingsProvider>(context,listen: false);
  }


  @override
  Widget build(BuildContext context) {
    settingsProvider=Provider.of<SettingsProvider>(context,listen: true);
    return BaseScreen( showSettings: false, showBottomBar: false, tag: "ContactUsScreen",
        body: Stack(children: [
          
          SingleChildScrollView(child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ActionBarWidget(
                  tr("contact_us"), context,
                  enableShadow:false,
                  showSetting:true,
                  textColor:Colors.white,
                  showBack: true,
                  backgroundColor:C.BASE_BLUE

              ),
              Container(
                  margin: EdgeInsets.only(top:D.default_150,bottom: D.default_30),
                  child: Center(child: Text(tr("contact_header1"),style: S.h1(color: C.BASE_BLUE),textAlign: TextAlign.center,),)),
              Container(
                  child: Center(child: Text(tr("${Constants.APP_INFO!.phone!}"),style: S.h1(),textAlign: TextAlign.center,),)),
              _header(),
              Container(
                padding: EdgeInsets.all(D.default_20),
                child: Form(
                  key: _loginFormGlobalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _name(),
                      _phone(),
                      _problim(),
                      _time(),
                      SizedBox(height: D.default_10,),
                      _sendBtn()

                    ],),),)
            ],),),
          settingsProvider!.isLoading?LoadingProgress():Container()
        ],));
  }
  Widget _sendBtn(){
    return Center(child: InkWell(
      onTap: (){
        if(!settingsProvider!.isLoading){
          onSendClicked();
        }
      },
      child: Container(
        width: D.default_200,
        margin: EdgeInsets.all(D.default_30),
        padding: EdgeInsets.only(left:D.default_20,right: D.default_20,top: D.default_10,bottom: D.default_10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(D.default_10),
            color: C.BASE_BLUE,
            boxShadow:[BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                offset:Offset(2,2),
                blurRadius:4,
                spreadRadius: 2
            )]
        ),
        child: Text(tr("send"),style: S.h2(color: Colors.white),textAlign:TextAlign.center ,),),),);
  }
  Widget _header(){
    return Container(
      padding: EdgeInsets.all(D.default_10),
      child: Center(child: Text(tr("contact_header2"),style: S.h1(color: C.BASE_BLUE),textAlign: TextAlign.center,),),);
  }
  Widget _phone(){
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _phoneController,
          validator: (phone){
            if(isFieldNotEmpty(phone!)){
              if(isPhoneValide(phone)){
                return null;
              }else{
                return tr("enter_10_numbers");
              }
            }else{
              return tr("enter_phone");
            }
          },
          decoration:  InputDecoration(
            labelText: tr("enter_phone"),
            labelStyle:S.h2(color: Colors.grey) ,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ) ,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.BASE_BLUE),
            ) ,
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.BASE_BLUE)
            ),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

          ),
          keyboardType: TextInputType.phone,
          obscureText: false,
          cursorColor: C.BASE_BLUE,
          autofocus: false,
        )
    );
  }
  Widget _name(){
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _nameController,
          validator: (name){
            if(isFieldNotEmpty(name!)){
              return null;
            }else{
              return "";
            }
          },
          decoration:  InputDecoration(
            labelText: tr("enter_name"),
            labelStyle:S.h2(color: Colors.grey) ,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ) ,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.BASE_BLUE),
            ) ,
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.BASE_BLUE)
            ),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.BASE_BLUE,
          autofocus: false,
        )
    );
  }
  Widget _problim(){
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _problimController,
          validator: (phone){
            if(isFieldNotEmpty(phone!)){
              return null;
            }else{
              return "";
            }
          },
          decoration:  InputDecoration(
            labelText: tr("enter_problim"),
            labelStyle:S.h2(color: Colors.grey) ,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ) ,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.BASE_BLUE),
            ) ,
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.BASE_BLUE)
            ),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.BASE_BLUE,
          autofocus: false,
        )
    );
  }
  Widget _time(){
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _timeController,
          validator: (phone){
            if(isFieldNotEmpty(phone!)){
              return null;
            }else{
              return "";
            }
          },
          decoration:  InputDecoration(
            labelText: tr("enter_time"),
            labelStyle:S.h2(color: Colors.grey) ,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ) ,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: C.BASE_BLUE),
            ) ,
            border: UnderlineInputBorder(
                borderSide: BorderSide(color: C.BASE_BLUE)
            ),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

          ),
          keyboardType: TextInputType.text,
          obscureText: false,
          cursorColor: C.BASE_BLUE,
          autofocus: false,
        )
    );
  }
  
  void onSendClicked(){
   settingsProvider!.contactUs(context, _nameController.text, _problimController.text, _phoneController.text, _timeController.text);
  }

}



