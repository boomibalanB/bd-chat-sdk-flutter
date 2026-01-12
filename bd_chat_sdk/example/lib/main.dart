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
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    sound: true,
    alert: true,
    badge: true,
  );
//   // Request Notification permission when user enter into application
await FirebaseMessaging.instance.requestPermission();
//   // Initialize Firebase Messaging services to receive Notifications
  NotificationService.firebaseMessagingInitialize();
//   // Get FCM Token Based
await NotificationService.getFCMToken();

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
  final bdChatSdkPlugin = BoldDeskChatSDK();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // BoldDeskChatSDK.applyCustomFontFamilyInAndroid(
    //                 bold: "dancingscript_bold",
    //                 semiBold: "dancingscript_semibold",
    //                 medium: "dancingscript_medium",
    //                 regular: "dancingscript_regular",
    //               );
    BoldDeskChatSDK.initialize("android_sdk_LjjZtgcIkOVZJA5z04ttkv2aiEdoTJQQuDj3d78oKQw", "https://dev-chat-integration.bolddesk.com");
    BoldDeskChatSDK.enableLogging();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HostAppUI(),
    );
  }
}

class HostAppUI extends StatefulWidget {
  @override
  _HostAppUIState createState() => _HostAppUIState();
}

class _HostAppUIState extends State<HostAppUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SDK Configuration",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  BoldDeskChatSDK.showChat();
                },
                child: Text("Show Chat", style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () {
                  BoldDeskChatSDK.clearSession();
                  NotificationService.disablePushNotification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Session cleared")),
                  );
                },
                child: Text("Clear Chat", style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () {
                  BoldDeskChatSDK.setPreferredTheme("light");
                },
                child: Text("Set light theme", style: TextStyle(color: Colors.blue)),
              ),
              TextButton(
                onPressed: () {
                  BoldDeskChatSDK.setPreferredTheme("dark");
                },
                child: Text("Set dark theme", style: TextStyle(color: Colors.blue)),
              ),
              ElevatedButton(
                  onPressed: () {
                    BoldDeskChatSDK.setUserEmail("prempk@gmail.com");
                    BoldDeskChatSDK.setUserName("Prem Kumar");
                    BoldDeskChatSDK.setUserPhoneNo("8569854125");
                  },
                  child: Text("Set User Data"),
                ),
              TextButton(
                onPressed: () {
                  BoldDeskChatSDK.applyTheme(
                    appbarColor: "#FF5733",
                    accentColor: "#33FF57",
                    backgroundColor: "#3357FF",
                    stickyButtonColor: "#F1C40F",
                  );
                },
                child: Text("Set custom theme", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
