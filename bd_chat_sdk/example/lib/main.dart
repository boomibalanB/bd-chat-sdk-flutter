import 'dart:io';

import 'package:bd_chat_sdk_example/firebase_options.dart';
import 'package:bd_chat_sdk_example/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bd_chat_sdk/bd_chat_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final savedAppToken = prefs.getString('appToken') ?? '';
    final savedDomainUrl = prefs.getString('domainUrl') ?? '';

    if (savedAppToken.isNotEmpty && savedDomainUrl.isNotEmpty) {
      BoldDeskChatSDK.initialize(savedAppToken, savedDomainUrl);
    } else {
      BoldDeskChatSDK.initialize(
        "android_sdk_idUR6cGkKubjs8g3fRy2mL0tDTTKfIh9qgDhE4bNo",
        "https://dev-chat-integration.bolddesk.com",
      );
    }
    BoldDeskChatSDK.enableLogging();
    // BoldDeskChatSDK.applyTheme(appbarColor : "#00F7FF", accentColor : "#A8DF8E", backgroundColor : "#F6F0D7", stickyButtonColor : "#AEDEFC");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HostAppUI());
  }
}

class HostAppUI extends StatefulWidget {
  const HostAppUI({Key? key}) : super(key: key);

  @override
  State<HostAppUI> createState() => _HostAppUIState();
}

class _HostAppUIState extends State<HostAppUI> {
  // Controllers for prefill fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Controllers for app configuration and user token
  final TextEditingController _appTokenController = TextEditingController();
  final TextEditingController _domainUrlController = TextEditingController();
  final TextEditingController _userTokenController = TextEditingController();

  // Controllers for custom fields
  final TextEditingController _customKeyController = TextEditingController();
  final TextEditingController _customValueController = TextEditingController();

  // Controllers for theme colors
  final TextEditingController _appbarColorController = TextEditingController(
    text: '#6200EE',
  );
  final TextEditingController _accentColorController = TextEditingController(
    text: '#03DAC6',
  );
  final TextEditingController _backgroundColorController =
      TextEditingController(text: '#FFFFFF');
  final TextEditingController _stickyButtonColorController =
      TextEditingController(text: '#FF0266');

  // Map to store custom fields
  final Map<String, dynamic> _customFields = {};

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _customKeyController.dispose();
    _customValueController.dispose();
    _appTokenController.dispose();
    _domainUrlController.dispose();
    _userTokenController.dispose();
    _appbarColorController.dispose();
    _accentColorController.dispose();
    _backgroundColorController.dispose();
    _stickyButtonColorController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedConfig();
  }

  Future<void> _loadSavedConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final appToken =
        prefs.getString('appToken') ??
        'android_sdk_idUR6cGkKubjs8g3fRy2mL0tDTTKfIh9qgDhE4bNo';
    final domainUrl =
        prefs.getString('domainUrl') ??
        'https://dev-chat-integration.bolddesk.com';
    final userToken = prefs.getString('userToken') ?? '';

    setState(() {
      _appTokenController.text = appToken;
      _domainUrlController.text = domainUrl;
      _userTokenController.text = userToken;
    });
  }

  dynamic _parseValue(String value) {
    value = value.trim();
    // Check for boolean
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;
    // Check for array format [1,2,3] or comma-separated values
    if (value.startsWith('[') && value.endsWith(']')) {
      final inner = value.substring(1, value.length - 1);
      return _parseArrayValue(inner);
    } else if (value.contains(',')) {
      return _parseArrayValue(value);
    }
    // Try to parse as number
    if (value.contains('.')) {
      final doubleValue = double.tryParse(value);
      if (doubleValue != null) return doubleValue;
    } else {
      final intValue = int.tryParse(value);
      if (intValue != null) return intValue;
    }
    // Default to string
    return value;
  }
  /// Parse array value (comma-separated)
  dynamic _parseArrayValue(String value) {
    final items = value.split(',').map((e) => e.trim()).toList();
    // Try to parse as List<int>
    final intList = <int>[];
    bool allInts = true;
    for (final item in items) {
      final intValue = int.tryParse(item);
      if (intValue != null) {
        intList.add(intValue);
      } else {
        allInts = false;
        break;
      }
    }
    if (allInts && intList.isNotEmpty) {
      return intList;
    }
    // Return as List<String>
    return items;
  }

  bool _validateHexColor(String color) {
    final hexRegex = RegExp(r'^#([0-9A-Fa-f]{6}|[0-9A-Fa-f]{8})$');
    return hexRegex.hasMatch(color);
  }

  void _applyCustomTheme() {
    final appbarColor = _appbarColorController.text.trim();
    final accentColor = _accentColorController.text.trim();
    final backgroundColor = _backgroundColorController.text.trim();
    final stickyButtonColor = _stickyButtonColorController.text.trim();

    // Validate all colors
    if (!_validateHexColor(appbarColor)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid Appbar color. Use hex format (e.g., #6200EE or #6200EEFF)',
          ),
        ),
      );
      return;
    }
    if (!_validateHexColor(accentColor)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Accent color. Use hex format')),
      );
      return;
    }
    if (!_validateHexColor(backgroundColor)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Background color. Use hex format')),
      );
      return;
    }
    if (!_validateHexColor(stickyButtonColor)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid Sticky Button color. Use hex format')),
      );
      return;
    }

    try {
      BoldDeskChatSDK.applyTheme(
        appbarColor: appbarColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        stickyButtonColor: stickyButtonColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Custom theme applied successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to apply theme: $e')));
    }
  }

  void _resetThemeColors() {
    setState(() {
      _appbarColorController.text = '#6200EE';
      _accentColorController.text = '#03DAC6';
      _backgroundColorController.text = '#FFFFFF';
      _stickyButtonColorController.text = '#FF0266';
    });
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      if (hex.length == 6) {
        return Color(int.parse('FF$hex', radix: 16));
      } else if (hex.length == 8) {
        return Color(int.parse(hex, radix: 16));
      }
    } catch (e) {
      // Return a default color if parsing fails
    }
    return Colors.grey;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 24),
            // SDK Configuration Section
            Text(
              "SDK Configuration",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // App configuration inputs
            TextField(
              controller: _appTokenController,
              decoration: InputDecoration(
                labelText: "App Token",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _domainUrlController,
              decoration: InputDecoration(
                labelText: "Domain URL",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final appToken = _appTokenController.text.trim();
                      final domainUrl = _domainUrlController.text.trim();
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('appToken', appToken);
                      await prefs.setString('domainUrl', domainUrl);

                      // Re-initialize SDK with new config
                      if (appToken.isNotEmpty && domainUrl.isNotEmpty) {
                        BoldDeskChatSDK.initialize(appToken, domainUrl);
                      }

                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Configuration saved")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 44),
                    ),
                    child: Text(
                      "Configure",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Session cleared")));
              },
              child: Text("Clear Chat", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {
                BoldDeskChatSDK.setPreferredTheme("light");
              },
              child: Text(
                "Set light theme",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                BoldDeskChatSDK.setPreferredTheme("dark");
              },
              child: Text(
                "Set dark theme",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                BoldDeskChatSDK.setSystemFontSize(enable: true);
              },
              child: Text(
                "Set System Font Size",
                style: TextStyle(color: Colors.blue),
              ),
            ),

            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),

            // Custom Theme Colors Section
            Text(
              "Custom Theme Colors",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            // Appbar Color
            _buildColorInputField(
              label: "Appbar Color",
              controller: _appbarColorController,
              placeholder: "#6200EE",
            ),
            SizedBox(height: 12),

            // Accent Color
            _buildColorInputField(
              label: "Accent Color",
              controller: _accentColorController,
              placeholder: "#03DAC6",
            ),
            SizedBox(height: 12),

            // Background Color
            _buildColorInputField(
              label: "Background Color",
              controller: _backgroundColorController,
              placeholder: "#FFFFFF",
            ),
            SizedBox(height: 12),

            // Sticky Button Color
            _buildColorInputField(
              label: "Sticky Button Color",
              controller: _stickyButtonColorController,
              placeholder: "#FF0266",
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyCustomTheme,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text(
                      "Apply Theme",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _resetThemeColors,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade600,
                      minimumSize: Size(double.infinity, 48),
                    ),
                    child: Text("Reset", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),

            // Prefill / Custom Fields Section
            Text(
              "Prefill / Custom Fields",
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),

            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),

            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),

            // Custom field key-value input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customKeyController,
                    decoration: InputDecoration(
                      labelText: "Key",
                      border: OutlineInputBorder(),
                      hintText: "e.g., chatCategoryId",
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _customValueController,
                    decoration: InputDecoration(
                      labelText: "Value",
                      border: OutlineInputBorder(),
                      hintText: "123, 2.5, true, [401,402]",
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final key = _customKeyController.text.trim();
                    final valueStr = _customValueController.text.trim();

                    if (key.isEmpty || valueStr.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Key and Value cannot be empty'),
                        ),
                      );
                      return;
                    }

                    try {
                      final parsedValue = _parseValue(valueStr);
                      setState(() {
                        _customFields[key] = _customValueController.text;
                        _customKeyController.clear();
                        _customValueController.clear();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Field added: $key = $parsedValue (${parsedValue.runtimeType})',
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.15),
                    foregroundColor: Colors.blue,
                  ),
                  child: Text("Add"),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Display custom fields
            if (_customFields.isNotEmpty) ...[
              SizedBox(height: 8),
              Text(
                'Added Fields:',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 4),
              ..._customFields.entries.map((entry) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      entry.value.runtimeType.toString(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue.shade800,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                entry.value.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade400),
                          onPressed: () {
                            setState(() {
                              _customFields.remove(entry.key);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],

            SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                BoldDeskChatSDK.setPrefillFields(
                  name: _nameController.text,
                  email: _emailController.text,
                  phoneNumber: _phoneController.text,
                  chatFields: _customFields,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Prefill fields applied")),
                );
              },
              child: Text(
                "Apply Custom Fields",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            SizedBox(height: 16),

            // User token input and save
            TextField(
              controller: _userTokenController,
              decoration: InputDecoration(
                labelText: "User Token",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final token = _userTokenController.text.trim();
                if (token.isNotEmpty) {
                  await BoldDeskChatSDK.setUserToken(token);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('userToken', token);
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("User token saved")));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text(
                "Save User Token",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorInputField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            // Color Preview Box
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _parseColor(controller.text),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                ),
                style: TextStyle(fontFamily: 'monospace', fontSize: 14),
                maxLength: 9,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
