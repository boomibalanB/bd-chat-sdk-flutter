import Flutter
import UIKit
import BoldDeskChatSDK

public class BdChatSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bd_chat_sdk", binaryMessenger: registrar.messenger())
    let instance = BdChatSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

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

      BDChatSDK.setPreferredTheme(preferredTheme)
      result(nil)
    case "enablePushNotification":
      guard let args = call.arguments as? [String: Any],
        let token = args["fcmToken"] as? String
      else {
        return
      }
      BDChatSDK.enablePushNotification(fcmToken: token ?? "")
      result(nil)   
    case "enableLogging":
      BDChatSDK.enableLogging()
      result(nil) 
    case "isChatOpen":
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

      BDChatSDK.setPrefillFields(email: email, name: name, phoneNo: phoneNumber, fields: chatFields)
      result(nil)
    case "setUserToken":
      guard let args = call.arguments as? [String: Any],
        let userToken = args["userToken"] as? String
      else {
        return
      }
      BDChatSDK.setUserToken(userToken)
      result(nil) 
    case "disablePushNotification":
      BDChatSDK.disablePushNotification()
      result(nil) 
    case "showChat":
      BDChatSDK.showChat()
      result(nil) 
    case "closeChat":
      BDChatSDK.closeChat()
      result(nil) 
    case "clearSession":
      BDChatSDK.clearSession()
      result(nil) 
    case "isFromChatSDK":
     if let args = call.arguments as? [String: Any],
        let messageData = args["messageData"] as? [AnyHashable: Any] {
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
      BDChatSDK.customFontName = fontFamily
      result(nil)
    case "setSystemFontSize":
      guard let args = call.arguments as? [String: Any],
        let enable = args["enable"] as? Bool
      else {
        return
      }
      BDChatSDK.applySystemFontSize = enable
      result(nil)
    case "applyTheme":
      let args = call.arguments as? [String: Any]

      let appbarColor = args?["appbarColor"] as? String
      let accentColor = args?["accentColor"] as? String
      let backgroundColor = args?["backgroundColor"] as? String
      let stickyButtonColor = args?["stickyButtonColor"] as? String

      BDChatSDK.applyTheme(
          appbarColor: appbarColor,
          accentColor: accentColor,
          backgroundColor: backgroundColor,
          stickyButtonColor: stickyButtonColor
      )
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
