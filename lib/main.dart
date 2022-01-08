import 'dart:developer';

import 'package:alefakaltawinea_animals_app/modules/baseScreen/baseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'modules/homeScreen/homeTabsScreen.dart';
import 'modules/spalshScreen/spalshScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'EG')],
      path: 'assets/strings', // <-- change the path of the translation files
      fallbackLocale: Locale('ar', 'EG'),
      child: MyApp()
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  BaseScreen(body: SplashScreen());
  }
}

