import Flutter
import UIKit
import BoldDeskChatSDK

public class BdChatSdkPlugin: NSObject, FlutterPlugin {
  private var channel: FlutterMethodChannel?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bd_chat_sdk", binaryMessenger: registrar.messenger())
    let instance = BdChatSdkPlugin()
    instance.channel = channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private let platform: String = "Flutter"
  private let sdkVersion: String = "5.0.2"

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method {
    case "configure":
      guard let args = call.arguments as? [String: Any],
        let appKey = args["appKey"] as? String,
        let brandUrl = args["brandUrl"] as? String,
        let culture = args["culture"] as? String
      else {
        result(["success": false, "message": "Missing arguments"])
        return
      }
      
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.configure(appKey: appKey, brandUrl: brandUrl, culture)
      result(nil)
    case "setPreferredTheme":
      guard let args = call.arguments as? [String: Any],
        let themeString = args["theme"] as? String
      else {
        result(["success": false, "message": "Missing theme"])
        return
      }

      let preferredTheme: SDKTheme
      switch themeString.lowercased() {
      case "light":
        preferredTheme = .light
      case "dark":
        preferredTheme = .dark
      default:
        preferredTheme = .system
      }

      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.setPreferredTheme(preferredTheme)
      result(nil)
    case "enablePushNotification":
      guard let args = call.arguments as? [String: Any],
        let token = args["fcmToken"] as? String
      else {
        return
      }
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.enablePushNotification(fcmToken: token ?? "")
      result(nil)   
    case "enableLogging":
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.enableLogging()
      result(nil) 
    case "isChatOpen":
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      let isChatOpen = BDChatSDK.isChatOpen()
      result(isChatOpen) 
    case "setPrefillFields":
      let args = call.arguments as? [String: Any]
      let name = args?["name"] as? String
      let email = args?["email"] as? String
      let phoneNumber = args?["phoneNumber"] as? String
      let rawChatFields = args?["chatFields"] as? [String: Any]
      var chatFields: [String: Any]? = nil
      if let raw = rawChatFields {
        var cleaned = [String: Any]()
        for (k, v) in raw {
          if !(v is NSNull) {
            cleaned[k] = v
          }
        }
        if !cleaned.isEmpty { chatFields = cleaned }
      }

      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.setPrefillFields(email: email, name: name, phoneNo: phoneNumber, fields: chatFields)
      result(nil)
    case "setUserToken":
      guard let args = call.arguments as? [String: Any],
        let userToken = args["userToken"] as? String
      else {
        return
      }
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.setUserToken(userToken)
      result(nil) 
    case "disablePushNotification":
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.disablePushNotification()
      result(nil) 
    case "showChat":
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.showChat()
      result(nil) 
    case "closeChat":
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.closeChat()
      result(nil) 
    case "clearSession":
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.clearSession()
      result(nil) 
    case "isFromChatSDK":
     if let args = call.arguments as? [String: Any],
        let messageData = args["messageData"] as? [AnyHashable: Any] {
          BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
          let isFromSDK = BDChatSDK.isFromChatSDK(userInfo: messageData)
        result(isFromSDK)
      } else {
          result(false)
      }
    case "applyCustomFontFamilyInIOS":
      guard let args = call.arguments as? [String: Any],
        let fontFamily = args["fontFamily"] as? String
      else {
        return
      }
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.customFontName = fontFamily
      result(nil)
    case "handlePushNotification":
      if let args = call.arguments as? [String: Any],
        let messageData = args["messageData"] as? [String: String] {

          BDChatSDK.handlePushNotification(userInfo: messageData)
          result(true)
      } else {
          result(false)
      }
    case "setSystemFontSize":
      guard let args = call.arguments as? [String: Any],
        let enable = args["enable"] as? Bool
      else {
        return
      }
      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.applySystemFontSize = enable
      result(nil)
    case "applyTheme":
      let args = call.arguments as? [String: Any]

      let appbarColor = args?["appbarColor"] as? String
      let accentColor = args?["accentColor"] as? String
      let backgroundColor = args?["backgroundColor"] as? String
      let stickyButtonColor = args?["stickyButtonColor"] as? String

      BDChatSDK.setPlatform(sdkPlatform: platform, sdkVersion: sdkVersion)
      BDChatSDK.applyTheme(
          appbarColor: appbarColor,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          stickyButtonColor: stickyButtonColor
      )
      result(nil)
    case "setOnTicketCreatedListener":
      let args = call.arguments as? [String: Any]
      let enabled = args?["enabled"] as? Bool ?? false

      if enabled {
          BDChatSDK.onTicketCreatedEventCallBack = { [weak self] ticketId in
              self?.channel?.invokeMethod(
                  "onTicketCreated",
                  arguments: ticketId
              )
          }
      } else {
          BDChatSDK.onTicketCreatedEventCallBack = nil
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
