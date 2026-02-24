import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bd_chat_sdk_platform_interface.dart';

/// An implementation of [BdChatSdkPlatform] that uses method channels.
class MethodChannelBdChatSdk extends BdChatSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bd_chat_sdk');

  @override
  Future<void> configure(String appKey, String brandUrl, [String? culture]) async {
    await methodChannel.invokeMethod('configure', {
      'appKey': appKey,
      'brandUrl': brandUrl,
      'culture': culture
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
    await methodChannel.invokeMethod('enablePushNotification', {
      'fcmToken': fcmToken,
    });
  }

  @override
  Future<void> setPrefillFields({
    String? name,
    String? email,
    String? phoneNumber,
    Map<String, Object?>? chatFields,
  }) async {
    final args = <String, Object?>{};
    if (name != null) args['name'] = name;
    if (email != null) args['email'] = email;
    if (phoneNumber != null) args['phoneNumber'] = phoneNumber;
    if (chatFields != null) args['chatFields'] = chatFields;

    await methodChannel.invokeMethod('setPrefillFields', args);
  }

  @override
  Future<void> setUserToken(String userToken) async {
    await methodChannel.invokeMethod('setUserToken', {'userToken': userToken});
  }

  @override
  Future<void> disablePushNotification() async {
    await methodChannel.invokeMethod('disablePushNotification');
  }

  @override
  Future<void> handleAndroidNotification(Map<String, dynamic> body, String notificationIconPath) async {
    final ByteData data = await rootBundle.load(notificationIconPath);
    final Uint8List iconBytes = data.buffer.asUint8List();
    await methodChannel.invokeMethod('handlePushNotifications', {
      'body': body,
      'notificationIcon': iconBytes,
    });
  }

  @override
  Future<bool> handleiOSPushNotification(Map<String, dynamic> messageData) async {
    final safeData = messageData.map(
      (k, v) => MapEntry(k, v.toString()),
    );

    return await methodChannel.invokeMethod(
      'handlePushNotification',
      {'messageData': safeData},
    );
  }

  @override
  Future<bool> isFromChatSDK(Map<String, dynamic> messageData) async {
    return await methodChannel.invokeMethod('isFromChatSDK', {
      'messageData': messageData,
    });
  }

  @override
  Future<void> applyCustomFontFamilyInAndroid(
    String regular,
    String medium,
    String semiBold,
    String bold,
  ) async {
    await methodChannel.invokeMethod('applyCustomFontFamilyInAndroid', {
      'regular': regular,
      'medium': medium,
      'semiBold': semiBold,
      'bold': bold,
    });
  }

  @override
  Future<void> applyCustomFontFamilyInIOS(String fontFamily) async {
    await methodChannel.invokeMethod('applyCustomFontFamilyInIOS', {
      'fontFamily': fontFamily,
    });
  }

  @override
  Future<void> applyTheme({
    String? appbarColor,
    String? accentColor,
    String? backgroundColor,
    String? stickyButtonColor,
  }) async {
    await methodChannel.invokeMethod('applyTheme', {
      'appbarColor': appbarColor,
      'accentColor': accentColor,
      'backgroundColor': backgroundColor,
      'stickyButtonColor': stickyButtonColor,
    });
  }

  @override
  Future<void> setSystemFontSize(bool enable) async {
    await methodChannel.invokeMethod('setSystemFontSize', {'enable': enable});
  }
}
