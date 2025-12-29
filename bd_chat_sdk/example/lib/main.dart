import 'dart:io';

import 'package:bd_chat_sdk_example/firebase_options.dart';
import 'package:bd_chat_sdk_example/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bd_chat_sdk/bd_chat_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase services
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    sound: true,
    alert: true,
    badge: true,
  );
  // Request Notification permission when user enter into application
  await FirebaseMessaging.instance.requestPermission();
  // Initialize Firebase Messaging services to receive Notifications
  NotificationService.firebaseMessagingInitialize();
  // Get FCM Token Based
  NotificationService.getFCMToken();

  // Handle notification when app is terminated state (iOS only)
  if (Platform.isIOS) {
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        // BoldDeskSupportSDK.handleNotification(message.data);
      }
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bdChatSdkPlugin = BoldDeskChatSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    BoldDeskChatSdk.initialize("ios_sdk_JF1jhmdlO9Hj09IbqIfnTqNvl4IK5wkCtabgmTsAbg", "https://dev-chat-integration.bolddesk.com");  
    BoldDeskChatSdk.setPreferredTheme("light");
    BoldDeskChatSdk.setSystemFontSize(false);
    BoldDeskChatSdk.setLoggingEnabled();
    // BoldDeskChatSdk.setUserEmail("boomibalan12@gmail.com");
    // BoldDeskChatSdk.setUserPhoneNo("7825063556");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(onPressed: (){
                BoldDeskChatSdk.applyCustomFontFamilyInIOS("Dancing Script");
                BoldDeskChatSdk.setUserName("boomi");
                BoldDeskChatSdk.setUserEmail("boomi@gmail.com");
                BoldDeskChatSdk.showChat();
                }, child: Text("ShowChat")),
              TextButton(onPressed: BoldDeskChatSdk.closeChat, child: Text("Close Chat")),
              TextButton(onPressed: BoldDeskChatSdk.clearSession, child: Text("Clear Session")),
            ],
          ),
        ),
      ),
    );
  }
}
