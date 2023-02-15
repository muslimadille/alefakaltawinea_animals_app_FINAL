import 'dart:convert';
import 'dart:io';

import 'package:alefakaltawinea_animals_app/modules/cart/add_cart_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/categories_screen/mainCategoriesScreen.dart';
import 'package:alefakaltawinea_animals_app/modules/registeration/registration_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/details_screen/service_provider_details_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/getServiceProvidersApi.dart';
import 'package:alefakaltawinea_animals_app/modules/serviceProviders/list_screen/data/serviceProvidersModel.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FCM extends Object{
  @pragma('vm:entry-point')
  static void myBackgroundMessageHandler(NotificationResponse response) {
    if (true) {
       Fluttertoast.showToast(msg:tr("xxxxxx${response.payload}") );
    }

    // Or do other work.
  }
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String FCM_TOKEN="";
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(
      debugLabel: "Main Navigator");

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    Map<String,dynamic> messageMap=json.decode(message.data["data"]);
    if (notification != null) {
      if(android!=null){
        await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            Constants.utilsProviderModel!.isArabic?messageMap["notification_title"]??"":messageMap["notification_title_en"]??"",
            Constants.utilsProviderModel!.isArabic?messageMap["notification_data"]["message"]:messageMap["notification_data"]["message_en"],
            NotificationDetails(
                android: AndroidNotificationDetails("com.google.firebase.messaging.default_notification_channel_id","")
            ),payload: "${messageMap["notification_data"]["type"].toString()}#${messageMap["notification_data"]["ads_id"].toString()}#${messageMap["notification_data"]["url"].toString()}");
      }else{
        /*await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            Constants.utilsProviderModel!.isArabic?messageMap["notification_title"]??"":messageMap["notification_title_en"]??"",
            Constants.utilsProviderModel!.isArabic?messageMap["notification_data"]["message"]:messageMap["notification_data"]["message_en"],
            NotificationDetails(
              iOS: DarwinNotificationDetails(),
            ),payload: "${messageMap["notification_data"]["type"].toString()}#${messageMap["notification_data"]["ads_id"].toString()}#${messageMap["notification_data"]["url"].toString()}");*/
      }

    }
  }
  openClosedAppFromNotification()async{

    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      await Fluttertoast.showToast(msg: tr("initialMessage:${initialMessage}"),backgroundColor: Colors.red,textColor: Colors.white,);
      Map<String,dynamic> messageMap=json.decode(initialMessage.data["data"]);
      await serialiseAndNavigate(NotificationResponse(notificationResponseType:NotificationResponseType.selectedNotification,
          payload:"${messageMap["notification_data"]["type"].toString()}#${messageMap["notification_data"]["ads_id"].toString()}#${messageMap["notification_data"]["url"].toString()}" ));
    }
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
    if(notificationAppLaunchDetails!.didNotificationLaunchApp){
      await Fluttertoast.showToast(msg: tr("payload:${notificationAppLaunchDetails.notificationResponse!.payload}"),backgroundColor: Colors.red,textColor: Colors.white,);

      await serialiseAndNavigate(notificationAppLaunchDetails.notificationResponse);
    }

  }
   init()async{

     await firebaseMessaging.app.setAutomaticDataCollectionEnabled(true);
     /// open app work on background only
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Map<String,dynamic> messageMap=json.decode(message.data["data"]);
      serialiseAndNavigate(NotificationResponse(notificationResponseType:NotificationResponseType.selectedNotification,
          payload:"${messageMap["notification_data"]["type"].toString()}#${messageMap["notification_data"]["ads_id"].toString()}#${messageMap["notification_data"]["url"].toString()}" ));
    });
    ///background message
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
     ///foreground message
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       RemoteNotification? notification = message.notification;

       AndroidNotification? android = message.notification?.android;
       Map<String,dynamic> messageMap=json.decode(message.data["data"]);
       if (notification != null) {
         if(android!=null){
           flutterLocalNotificationsPlugin.show(
               notification.hashCode,
               Constants.utilsProviderModel!.isArabic?messageMap["notification_title"]??"":messageMap["notification_title_en"]??"",
               Constants.utilsProviderModel!.isArabic?messageMap["notification_data"]["message"]:messageMap["notification_data"]["message_en"],
               NotificationDetails(
                   android: AndroidNotificationDetails(
                       "alefak","alefak",
                       importance: Importance.max,
                       priority: Priority.high,
                       styleInformation: BigTextStyleInformation('')
                   ),
               ),payload: "${messageMap["notification_data"]["type"].toString()}#${messageMap["notification_data"]["ads_id"].toString()}#${messageMap["notification_data"]["url"].toString()}");
         }else{
           flutterLocalNotificationsPlugin.show(
               notification.hashCode,
               Constants.utilsProviderModel!.isArabic?messageMap["notification_title"]??"":messageMap["notification_title_en"]??"",
               Constants.utilsProviderModel!.isArabic?messageMap["notification_data"]["message"]:messageMap["notification_data"]["message_en"],
               NotificationDetails(
                   iOS: DarwinNotificationDetails(subtitle:notification.body),
               ),payload: "${messageMap["notification_data"]["type"].toString()}#${messageMap["notification_data"]["ads_id"].toString()}#${messageMap["notification_data"]["url"].toString()}");
         }

       }

     });

   }

    notificationSubscrib(bool isArabic)async{
    if(isArabic){
      await firebaseMessaging.unsubscribeFromTopic('users-en');
      await firebaseMessaging.subscribeToTopic('users-ar');
    }else{
      await firebaseMessaging.unsubscribeFromTopic('users-ar');
      await firebaseMessaging.subscribeToTopic('users-en');
    }

   }
  initInfo() async {
    Future.delayed(Duration(milliseconds: 100), () async {
      var initializationSettings;
      if(Platform.isAndroid){
        initializationSettings=InitializationSettings(android: AndroidInitializationSettings("mipmap/ic_launcher"));
      }else if(Platform.isIOS){
        initializationSettings=InitializationSettings(iOS:DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int? id, String? title, String? body, String? payload) async {

                }
        ) );
      }else{
        initializationSettings=InitializationSettings();
      }

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: serialiseAndNavigate,onDidReceiveBackgroundNotificationResponse: myBackgroundMessageHandler );

      if(Platform.isAndroid){
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
      }
      if(Platform.isIOS){
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
      }

      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    });

  }


  Future requestPermission()async{
    NotificationSettings settings =await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if(settings.authorizationStatus==AuthorizationStatus.authorized){
      print("fcm:permission success");
    }
  }
  Future getFCMToken() async {
    String? fcmToken = await firebaseMessaging.getToken();
    if (fcmToken != null) {
      FCM_TOKEN=fcmToken;
      print("fcm:$fcmToken");
    }

  }
  Future<void> serialiseAndNavigate(NotificationResponse? response) async{
    String type= (response!.payload??"").split("#")[0]??"";
    String providerId=(response.payload??"").split("#")[1]??"";
    String link=(response.payload??"").split("#")[2]??"";

    /// add card
    if (type=="1") {
       await Get.off(()=>MainCategoriesScreen(navigateTo:(){
        if(Constants.currentUser!=null){
           Get.to(()=>AddCartScreen());
        }else{
          Get.to(()=>RegistrationScreen(fromaddcard:true));
        }
      } ,),preventDuplicates: false);
      return;
    }
    /// service provider
    if(type=="2"){
      Get.back();
       await Get.off(()=>MainCategoriesScreen(navigateTo:()async{
        GetServiceProvidersApi api=GetServiceProvidersApi();
        await api.getServiceProvider(int.parse(providerId.isNotEmpty?providerId:"0")).then((value){
          Data provide=value.data;
          Get.to(()=>ServiceProviderDetailsScreen(provide));
        });
      } ,),preventDuplicates: false);
      return;
    }
    /// url
    if (type=="3") {
       await Get.off(()=>MainCategoriesScreen(navigateTo:() async{
        final String ure=link;
        String  url = ure;
        if (await canLaunch(url)) {
        await launch(url);
        } else {
        await Fluttertoast.showToast(msg: tr("cant_opn_url"),backgroundColor: Colors.red,textColor: Colors.white,);
        }
      } ,),preventDuplicates: false);

    }
  }
}