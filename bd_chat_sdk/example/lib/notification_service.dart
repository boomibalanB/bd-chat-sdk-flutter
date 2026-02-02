import 'dart:io';
import 'package:bd_chat_sdk/bd_chat_sdk.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma("vm:entry-point")
class NotificationService {
  // Initialize FirebaseMessingService to listen Messages
  static void firebaseMessagingInitialize() {
    onBackgroundMessage();
    onMessage();

    if (Platform.isIOS) {
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        BoldDeskChatSDK.showChat();
      });
    }
  }

  // this used to receive message when app in background
  @pragma("vm:entry-point")
  static Future<void> backgroundHandler(RemoteMessage message) async {
    // Icon should be Drawable source
    if (Platform.isAndroid) {
      var isFromMobileSDK = await BoldDeskChatSDK.isFromChatSDK(message.data);
      if(isFromMobileSDK) {
        BoldDeskChatSDK.handleAndroidNotification(message.data, "sample_app_logo");
      }
    }
  }

  static void onBackgroundMessage() {
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  }

  static Future<void> getFCMToken() async {
    if (Platform.isIOS) {
      // Wait for APNS token to be ready
      String? apnsToken;
      for (int i = 0; i < 10; i++) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken != null) break;
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null && fcmToken.isNotEmpty) {
      BoldDeskChatSDK.enablePushNotification(fcmToken);
    }
  }

  static void onMessage() {
    FirebaseMessaging.onMessage.listen((message) async {
      if (Platform.isAndroid) {
        var isFromMobileSDK = await BoldDeskChatSDK.isFromChatSDK(message.data);
        if(isFromMobileSDK) {
        BoldDeskChatSDK.handleAndroidNotification(message.data, "sample_app_logo");
        }
      }
    });
  }

  static void disablePushNotification() {
    BoldDeskChatSDK.disablePushNotification();
  }
}
