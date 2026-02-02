import 'dart:io';

import 'package:bd_support_sdk/bolddesk_support_sdk.dart';
import 'package:bolddesk_supportsdk_example/firebase_options.dart';
import 'package:bolddesk_supportsdk_example/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize firebase services
  await Firebase.initializeApp(
    name: "bolddesk_sdk_sample",
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
  await NotificationService.getFCMToken();

  // Handle notification when app is terminated state (iOS only)
  if (Platform.isIOS) {
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        BoldDeskSupportSDK.handleIOSNotification(message.data);
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
  @override
  void initState() {
    super.initState();
  }

  String generateJwt({required String secretKey, required String email}) {
    // iat in seconds since epoch (UTC)
    final issuedAt = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

    final jwt = JWT({'email': email, 'name': "", 'iat': issuedAt});

    // Sign with HS256
    final token = jwt.sign(SecretKey(secretKey), algorithm: JWTAlgorithm.HS256);

    return token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Plugin example app')),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.showHome();
                },
                child: Text("Show Home"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.showKB();
                },
                child: Text("Show KB"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.openArticleDetailsPage(
                    0, //article Id
                    "YOUR_ARTICLE_SLUGTITLE",
                  );
                },
                child: Text("open ArticleDetails Page"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.showCreateTicket();
                },
                child: Text("Show Create Ticket"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.initialize(
                    "YOUR_APP_ID",
                    "YOUR_BRAND_URL",
                    onSuccess: (message) {
                      print("SDK Initialized Successfully: $message");
                    },
                    onError: (error) {
                      print("SDK Initialization Failed: $error");
                    },
                  );
                },
                child: Text("initialize SDK"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await BoldDeskSupportSDK.isLoggedIn()) {
                    print("User already logged in");
                  } else {
                    var jwtToken = generateJwt(
                      secretKey: "YOUR_JWT_SECRET_KEY",
                      email: "USER_MAIL_ID",
                    );
                    BoldDeskSupportSDK.loginWithJWTToken(
                      jwtToken,
                      onSuccess: (message) {
                        print("SDK Initialized Successfully: $message");
                      },
                      onError: (error) {
                        print("SDK Initialization Failed: $error");
                      },
                    );
                  }
                },
                child: Text("Login"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.applyTheme("#FF0000", "#00FF00");
                },
                child: Text("Theme Color Change"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.setPreferredTheme("system");
                },
                child: Text("ThemeMode"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.logout();
                },

                child: Text("Logout"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.applyCustomFontFamilyInIOS(
                    "Times New Roman",
                  );
                },
                child: Text("Font Family"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.setSystemFontSize(false);
                },
                child: Text("Font Size"),
              ),

              ElevatedButton(
                onPressed: () async {
                  var result = await BoldDeskSupportSDK.isLoggedIn();
                  print("result: $result");
                },
                child: Text("is Logged in"),
              ),

              ElevatedButton(
                onPressed: () async {
                  final Map<String, dynamic> userInfo = {
                    "data": {"userId": "USER_ID", "email": "USER_MAIL_ID"},
                    "timestamp": DateTime.now().toIso8601String(),
                    "source": "mobile_app",
                  };

                  var result = await BoldDeskSupportSDK.isFromMobileSDK(
                    userInfo,
                  );
                  print("result: $result");
                },
                child: Text("is form sdk"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.clearallLocalData();
                },
                child: Text("Clear data"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSDKHome.setHeaderLogo("YOUR_HEADER_IMAGE_URL");
                },
                child: Text("Header Logo"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSDKHome.setHomeDashboardContent(
                    headerName: "Custom Header",
                    headerDescription: "This is custom header description",
                    kbTitle: "Custom KB Title",
                    kbDescription: "This is custom KB description",
                    ticketTitle: "Custom Ticket Title",
                    ticketDescription: "This is custom Ticket description",
                    submitButtonText: "Send Now",
                  );
                },
                child: Text("set custom content"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.setLoggingEnabled(true);
                },
                child: Text("Set Logging Enabled"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.applyCustomFontFamilyInAndroid(
                    bold: "dancingscript_bold",
                    semiBold: "dancingscript_semibold",
                    medium: "dancingscript_medium",
                    regular: "dancingscript_regular",
                  );
                },
                child: Text("Set Custom Font Family Android"),
              ),

              ElevatedButton(
                onPressed: () {
                  BoldDeskSupportSDK.setFCMRegistrationToken(
                    "YOUR_FCM_REGISTRATION_TOKEN",
                  );
                },
                child: Text("Set FCM Token"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
