import 'bd_chat_sdk_platform_interface.dart';

class BoldDeskChatSDK {
  static Future<void> initialize(String appKey, String brandUrl) {
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

  static Future<void> enableLogging() {
    return BdChatSdkPlatform.instance.enableLogging();
  }

  static Future<void> setPreferredTheme(String theme) {
    return BdChatSdkPlatform.instance.setPreferredTheme(theme);
  }

  static Future<void> enablePushNotification(String fcmToken) {
    return BdChatSdkPlatform.instance.enablePushNotification(fcmToken);
  }

  static Future<void> setPrefillFields({
    String? name,
    String? email,
    String? phoneNumber,
    Map<String, Object?>? chatFields,
  }) {
    return BdChatSdkPlatform.instance.setPrefillFields(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      chatFields: chatFields,
    );
  }

  static Future<void> setUserToken(String userToken) {
    return BdChatSdkPlatform.instance.setUserToken(userToken);
  }

  static Future<void> disablePushNotification() {
    return BdChatSdkPlatform.instance.disablePushNotification();
  }

  static Future<void> handleAndroidNotification(
    Map<String, dynamic> body,
    String notificationIcon,
  ) {
    return BdChatSdkPlatform.instance.handleAndroidNotification(
      body,
      notificationIcon,
    );
  }

  static Future<bool> isFromChatSDK(Map<String, dynamic> messageData) {
    return BdChatSdkPlatform.instance.isFromChatSDK(messageData);
  }

  static Future<void> applyCustomFontFamilyInAndroid({
    required String regular,
    required String medium,
    required String semiBold,
    required String bold,
  }) {
    return BdChatSdkPlatform.instance.applyCustomFontFamilyInAndroid(
      regular,
      medium,
      semiBold,
      bold,
    );
  }

  static Future<void> applyCustomFontFamilyInIOS(String fontFamily) {
    return BdChatSdkPlatform.instance.applyCustomFontFamilyInIOS(fontFamily);
  }

  static Future<void> applyTheme({
    String? appbarColor,
    String? accentColor,
    String? backgroundColor,
    String? stickyButtonColor,
  }) {
    return BdChatSdkPlatform.instance.applyTheme(
      appbarColor: appbarColor,
      accentColor: accentColor,
      backgroundColor: backgroundColor,
      stickyButtonColor: stickyButtonColor,
    );
  }

  static Future<void> setSystemFontSize({required bool enable}) {
    return BdChatSdkPlatform.instance.setSystemFontSize(enable);
  }
}
