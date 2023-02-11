import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/login/provider/user_provider_model.dart';
import 'package:alefakaltawinea_animals_app/modules/otp/phone_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/registeration/registration_screen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseDimentions.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/baseTextStyle.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/input%20_validation_mixing.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myColors.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:alefakaltawinea_animals_app/utils/my_widgets/laoding_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../utils/my_widgets/action_bar_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with  InputValidationMixin{
  TextEditingController _phoneController=TextEditingController();
  TextEditingController _passwordController=TextEditingController();
  final _loginFormGlobalKey = GlobalKey < FormState > ();
  bool passwordobsecure=true;
  UserProviderModel?userProviderModel;
@override
  void initState() {
    super.initState();
    userProviderModel=Provider.of<UserProviderModel>(context,listen: false);
  }


  @override
  Widget build(BuildContext context) {
    userProviderModel=Provider.of<UserProviderModel>(context,listen: true);

    return BaseScreen( showSettings: false, showBottomBar: false, tag: "LoginScreen",
      body: userProviderModel!.isLoading?LoadingProgress():
      SingleChildScrollView(child: Column(children: [
        ActionBarWidget(
            "", context,
            enableShadow:false,
            showSetting:false,
            textColor:C.BASE_BLUE,
            backgroundColor:Colors.white

        ),
        SingleChildScrollView(child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(top:D.default_50,bottom: D.default_30),
                child: Center(child: Text(tr("welcome_back"),style: S.h1Bold(color: C.BASE_BLUE),textAlign: TextAlign.center,),)),
            _header(),
            Container(
              padding: EdgeInsets.all(D.default_50),
              child: Form(
                key: _loginFormGlobalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _phone(),
                    _password(),
                    SizedBox(height: D.default_10,),
                    _forgetPassword(),
                    _loginBtn(),
                    dont_have_account()

                  ],),),)
          ],),)
      ],)),);
  }
  Widget dont_have_account(){
    return Container(child:Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(tr("dont_have_acout"),style: S.h5(color: Colors.grey,fontSize: D.textSize(5)),),
        SizedBox(width: D.default_10,),
        InkWell(
          onTap: (){
            MyUtils.navigateReplaceCurrent(context, RegistrationScreen());
          },
          child: Text(tr("register"),style: S.h1(color: C.BASE_BLUE,fontSize: D.textSize(5)),),)
      ],));
  }
  Widget _loginBtn(){
    return Center(child: InkWell(
      onTap: (){
        _onLoginClicked();
      },
      child: Container(
        width: D.default_150,
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
        child: Text(tr("login"),style: S.h1(color: Colors.white),textAlign:TextAlign.center ,),),),);
  }
  Widget _header(){
    return Container(
      padding: EdgeInsets.all(D.default_10),
      child: Center(child: Text(tr("login_header"),style: S.h1Bold(color: C.BASE_BLUE),textAlign: TextAlign.center,),),);
  }
  Widget _password(){
    return Container(
        width: double.infinity,
        child: TextFormField(
          controller: _passwordController,
          validator:(password){
            if(isFieldNotEmpty(password!)){
              if(isPasswordValide(password)){
                return null;
              }else{
                return tr("password_length");
              }
            }else{
              return tr("enter_password");
            }
          } ,
          style: S.h2(color: Colors.black),
          decoration:  InputDecoration(
            labelText: tr("enter_password"),
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
              suffixIcon: IconButton(onPressed: (){
                setState(() {
                  passwordobsecure?passwordobsecure=false:passwordobsecure=true;
                });
              },icon: Icon((passwordobsecure) ? Icons.visibility_off : Icons.visibility,color: Colors.grey,),),
            errorStyle: S.h4(color: Colors.red),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          ),
          keyboardType: TextInputType.text,
          obscureText: passwordobsecure,
          cursorColor: C.BASE_BLUE,
          autofocus: false,
        )
    );
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
            labelText: tr("phone"),
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
  Widget _forgetPassword(){
    return InkWell(onTap: (){
      MyUtils.navigate(context, PhoneScreen(tr("forget_password_title"),"ForgetPasswordScreen" ));
    },child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(D.default_10),
      child: Text(tr("forget_password"),style: S.h4(color: Colors.black),textAlign:TextAlign.end,),),);
  }
  void _onLoginClicked(){
    if (_loginFormGlobalKey.currentState!.validate()) {
      _loginFormGlobalKey.currentState!.save();
      //call login api
      userProviderModel!.login(
        MyUtils.replaceArabicNumber(_phoneController.text)
          , _passwordController.text,context,false);
    }
  }
 initSavedUser(){
  if( Constants.prefs!.get(Constants.SAVED_PHONE_KEY!)!=null&&Constants.prefs!.get(Constants.SAVED_PASSWORD_KEY!)!=null){
    userProviderModel!.login(Constants.prefs!.get(Constants.SAVED_PHONE_KEY!).toString(),Constants.prefs!.get(Constants.SAVED_PASSWORD_KEY!).toString(),context,false);
  }
 }
}



