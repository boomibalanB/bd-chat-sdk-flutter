
import 'bd_chat_sdk_platform_interface.dart';

class BoldDeskChatSDK {
  static Future<void> initialize(
    String appKey,
    String brandUrl) {
    return BdChatSdkPlatform.instance.configure(appKey, brandUrl);
  }

  static Future<void> showChat() {
    return BdChatSdkPlatform.instance.showChat();
  }

  static Future<void> closeChat() {
    return BdChatSdkPlatform.instance.closeChat();
  }

  static Future<void> clearSession() {
    return BdChatSdkPlatform.instance.clearSession();
  }

  static Future<void> setLoggingEnabled() {
    return BdChatSdkPlatform.instance.setLoggingEnabled();
  }

  static Future<void> setPreferredTheme(String theme) {
    return BdChatSdkPlatform.instance.setPreferredTheme(theme);
  }

  static Future<void> setFCMRegistrationToken(String token) {
    return BdChatSdkPlatform.instance.setFCMRegistrationToken(token);
  }

  static Future<bool> isChatOpen() {
    return BdChatSdkPlatform.instance.isChatOpen();
  }

  static Future<void> setUserEmail(String email) {
    return BdChatSdkPlatform.instance.setUserEmail(email);
  }

  static Future<void> setUserName(String name) {
    return BdChatSdkPlatform.instance.setUserName(name);
  }

  static Future<void> setUserPhoneNo(String phoneNo) {
    return BdChatSdkPlatform.instance.setUserPhoneNo(phoneNo);
  }

  static Future<void> setUserToken(String userToken) {
    return BdChatSdkPlatform.instance.setUserToken(userToken);
  }

  static Future<void> disablePushNotification() {
    return BdChatSdkPlatform.instance.disablePushNotification();
  }

  static Future<void> isFromChatSDK(Map<String, dynamic> userInfo) {
    return BdChatSdkPlatform.instance.isFromChatSDK(userInfo);
  }

  static Future<void> applyCustomFontFamilyInIOS(String fontFamily) {
    return BdChatSdkPlatform.instance.applyCustomFontFamilyInIOS(fontFamily);
  }

  static Future<void> setSystemFontSize(bool enable) {
    return BdChatSdkPlatform.instance.setSystemFontSize(enable);
  }
}
