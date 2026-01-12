import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bd_chat_sdk_platform_interface.dart';

/// An implementation of [BdChatSdkPlatform] that uses method channels.
class MethodChannelBdChatSdk extends BdChatSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bd_chat_sdk');

  @override
  Future<void> configure(
    String appKey,
    String brandUrl) async {
    await methodChannel.invokeMethod('configure', {
        'appKey': appKey,
        'brandUrl': brandUrl,
      });
  }

  @override
  Future<void> showChat() async {
    await methodChannel.invokeMethod('showChat');
  }

  @override
  Future<void> closeChat() async {
    await methodChannel.invokeMethod('closeChat');
  }

  @override
  Future<void> clearSession() async {
    await methodChannel.invokeMethod('clearSession');
  }

  @override
  Future<void> enableLogging() async {
    await methodChannel.invokeMethod('enableLogging');
  }

  @override
  Future<void> setPreferredTheme(String theme) async {
    await methodChannel.invokeMethod('setPreferredTheme', {'theme': theme});
  }

  @override
  Future<void> enablePushNotification(String fcmToken) async {
    await methodChannel.invokeMethod('setFCMRegistrationToken', {
      'fcmToken': fcmToken,
    });
  }

  @override
  Future<void> setUserEmail(String email) async {
    await methodChannel.invokeMethod('setUserEmail', {
      'email': email,
    });
  }

  @override
  Future<void> setUserName(String name) async {
    await methodChannel.invokeMethod('setUserName', {
      'name': name,
    });
  }

  @override
  Future<void> setUserPhoneNo(String phoneNo) async {
    await methodChannel.invokeMethod('setUserPhoneNo', {
      'phoneNo': phoneNo,
    });
  }

  @override
  Future<void> setUserToken(String userToken) async {
    await methodChannel.invokeMethod('setUserToken', {
      'userToken': userToken,
    });
  }

  @override
  Future<void> disablePushNotification(String fcmToken) async {
    await methodChannel.invokeMethod('disablePushNotification', {
      'fcmToken': fcmToken
    });
  }

  @override
  Future<void> handleAndroidNotification(Map<String, dynamic> body, String notificationIcon) async {
    await methodChannel.invokeMethod('handlePushNotifications', {
      'body': body,
      'notificationIcon': notificationIcon,
    });
  }

  @override
  Future<bool> isFromChatSDK(Map<String, dynamic> messageData) async {
    return await methodChannel.invokeMethod('isFromChatSDK',{
      'messageData': messageData
    });
  }

  @override
  Future<void> applyCustomFontFamilyInAndroid(String regular, String medium,String semiBold,String bold) async {
    await methodChannel.invokeMethod('applyCustomFontFamilyInAndroid', {
      'regular': regular,
      'medium': medium,
      'semiBold': semiBold,
      'bold': bold
    });
  }

  @override
  Future<void> applyCustomFontFamilyInIOS(String fontFamily) async {
    await methodChannel.invokeMethod('applyCustomFontFamilyInIOS', {
      'fontFamily': fontFamily,
    });
  }

   @override
  Future<void> applyTheme(
    {String? appbarColor,
    String? accentColor,
    String? backgroundColor,
    String? stickyButtonColor}) async {
    await methodChannel.invokeMethod('applyTheme', {
        'appbarColor': appbarColor,
        'accentColor': accentColor,
        'backgroundColor': backgroundColor,
        'stickyButtonColor': stickyButtonColor
      });
  }
}
