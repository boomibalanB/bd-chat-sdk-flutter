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
  Future<void> setLoggingEnabled() async {
    await methodChannel.invokeMethod('setLoggingEnabled');
  }

  @override
  Future<void> setPreferredTheme(String theme) async {
    await methodChannel.invokeMethod('setPreferredTheme', {'theme': theme});
  }

  @override
  Future<void> setFCMRegistrationToken(String token) async {
    await methodChannel.invokeMethod('setFCMRegistrationToken', {
      'token': token,
    });
  }

  @override
  Future<bool> isChatOpen() async {
    return await methodChannel.invokeMethod('isChatOpen');
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
  Future<void> disablePushNotification() async {
    await methodChannel.invokeMethod('disablePushNotification');
  }

  @override
  Future<bool> isFromChatSDK(Map<String, dynamic> userInfo) async {
    return await methodChannel.invokeMethod('isFromChatSDK');
  }

  @override
  Future<void> applyCustomFontFamilyInIOS(String fontFamily) async {
    await methodChannel.invokeMethod('applyCustomFontFamilyInIOS', {
      'fontFamily': fontFamily,
    });
  }

  @override
  Future<void> setSystemFontSize(bool enable) async {
    await methodChannel.invokeMethod('setSystemFontSize', {'enable': enable});
  }
}
