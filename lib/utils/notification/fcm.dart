import 'dart:io';

import 'package:alefakaltawinea_animals_app/modules/login/login_screen.dart';
import 'package:alefakaltawinea_animals_app/modules/spalshScreen/splash_two_screen.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/constants.dart';
import 'package:alefakaltawinea_animals_app/utils/my_utils/myUtils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCM extends Object{
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static String FCM_TOKEN="";

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null) {
      if(android!=null){
        await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails("alefak","alefak")
            ));
      }else{
        await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: DarwinNotificationDetails(subtitle:notification.body),
            ));
      }

    }
  }
   init()async{
     await FirebaseMessaging.instance.getInitialMessage();
    /// open app
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onResume: $message");
          (Map<String, dynamic> message) async => _serialiseAndNavigate(message);
    });
    ///background message
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
     ///foreground message
     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
       RemoteNotification? notification = message.notification;
       AndroidNotification? android = message.notification?.android;
       if (notification != null) {
         if(android!=null){
           flutterLocalNotificationsPlugin.show(
               notification.hashCode,
               notification.title,
               notification.body,
               NotificationDetails(
                   android: AndroidNotificationDetails("alefak","alefak")
               ));
         }else{
           flutterLocalNotificationsPlugin.show(
               notification.hashCode,
               notification.title,
               notification.body,
               NotificationDetails(
                   iOS: DarwinNotificationDetails(subtitle:notification.body),
               ));
         }

       }

     });

   }
  initInfo(){
    Future.delayed(Duration(milliseconds: 100), () async {
      await firebaseMessaging.subscribeToTopic('users');

      var initializationSettings;
      if(Platform.isAndroid){
        initializationSettings=InitializationSettings(android: AndroidInitializationSettings("mipmap/ic_launcher"));
      }else if(Platform.isIOS){
        initializationSettings=InitializationSettings(iOS:DarwinInitializationSettings() );
      }else{
        initializationSettings=InitializationSettings();
      }
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

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
  subscribeUserToken(String token){
    if ((Constants.currentUser)!=null) {
      //TODO SEND TOKEN TO SERVER
    }
  }



  void _serialiseAndNavigate(Map<String, dynamic> message) {
    if (Constants.currentUser!=null) {
      MyUtils.navigateAsFirstScreen(Constants.mainContext!, OnBoardingScreen());
      return;
    }
    if (message['data']['item_type'] == 'order') {
      MyUtils.navigateAsFirstScreen(Constants.mainContext!, OnBoardingScreen());
    } // If there's no view it'll just open the app on the first view
  }
}