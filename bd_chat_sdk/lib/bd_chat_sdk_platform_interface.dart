import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bd_chat_sdk_method_channel.dart';

abstract class BdChatSdkPlatform extends PlatformInterface {
  /// Constructs a BdChatSdkPlatform.
  BdChatSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static BdChatSdkPlatform _instance = MethodChannelBdChatSdk();

  /// The default instance of [BdChatSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelBdChatSdk].
  static BdChatSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BdChatSdkPlatform] when
  /// they register themselves.
  static set instance(BdChatSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> configure(
    String appKey,
    String brandUrl) {
    throw UnimplementedError('configure() has not been implemented.');
  }

  Future<void> showChat() {
    throw UnimplementedError('showChat() has not been implemented.');
  }

  Future<void> closeChat() {
    throw UnimplementedError('closeChat() has not been implemented.');
  }

  Future<void> clearSession() {
    throw UnimplementedError('clearSession() has not been implemented.');
  }

  Future<void> enableLogging() {
    throw UnimplementedError('setLoggingEnabled() has not been implemented.');
  }

  Future<void> setPreferredTheme(String theme) async {
    throw UnimplementedError('setPreferredTheme() has not been implemented.');
  }

  Future<void> enablePushNotification(String fcmToken) {
    throw UnimplementedError(
      'setFCMRegistrationToken() has not been implemented.',
    );
  }

  Future<void> setUserEmail(String email) async {
    throw UnimplementedError('setUserEmail() has not been implemented.');
  }

  Future<void> setUserName(String name) async {
    throw UnimplementedError('setUserName() has not been implemented.');
  }

  Future<void> setUserPhoneNo(String phoneNo) async {
    throw UnimplementedError('setUserPhoneNo() has not been implemented.');
  }

  Future<void> setUserToken(String userToken) async {
    throw UnimplementedError('setUserToken() has not been implemented.');
  }

  Future<void> disablePushNotification() async {
    throw UnimplementedError('disablePushNotification() has not been implemented.');
  }

  Future<void> handleAndroidNotification(Map<String, dynamic> body, String notificationIcon) async {
    throw UnimplementedError('handleAndroidNotification() has not been implemented.');
  }

  Future<bool> isFromChatSDK(Map<String, dynamic> messageData) async {
    throw UnimplementedError('isFromChatSDK() has not been implemented.');
  }

  Future<void> applyCustomFontFamilyInAndroid(String regular, String medium,String semiBold,String bold) async {
    throw UnimplementedError('applyCustomFontFamilyInAndroid() has not been implemented.');
  }

  Future<void> applyCustomFontFamilyInIOS(String fontFamily) async {
    throw UnimplementedError('applyCustomFontFamilyInIOS() has not been implemented.');
  }

  Future<void> applyTheme(
    {String? appbarColor,
    String? accentColor,
    String? backgroundColor,
    String? stickyButtonColor}) async {
    throw UnimplementedError('applyCustomFontFamilyInIOS() has not been implemented.');
  }
}
