import Flutter
import UIKit
import BoldDeskChatSDK

public class BdChatSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bd_chat_sdk", binaryMessenger: registrar.messenger())
    let instance = BdChatSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  private func convertToAnyHashable(_ dict: [String: Any]) -> [AnyHashable: Any] {
    Dictionary(uniqueKeysWithValues: dict.map { (AnyHashable($0.key), $0.value) })
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "configure":
      guard let args = call.arguments as? [String: Any],
        let appKey = args["appKey"] as? String,
        let brandUrl = args["brandUrl"] as? String
      else {
        result(["success": false, "message": "Missing arguments"])
        return
      }
      
      BDChatSDK.configure(appKey: appKey, brandUrl: brandUrl)
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
    case "setFCMRegistrationToken":
      guard let args = call.arguments as? [String: Any],
        let token = args["token"] as? String
      else {
        return
      }
      BDChatSDK.enablePushNotification(fcmToken: token ?? "")
      result(nil)   
    case "setLoggingEnabled":
      BDChatSDK.enableLogging()
      result(nil) 
    case "isChatOpen":
      let isChatOpen = BDChatSDK.isChatOpen()
      result(isChatOpen) 
    case "setUserEmail":
      guard let args = call.arguments as? [String: Any],
        let email = args["email"] as? String
      else {
        return
      }
      BDChatSDK.setUserEmail(email)
      result(nil)   
    case "setUserName":
      guard let args = call.arguments as? [String: Any],
        let name = args["name"] as? String
      else {
        return
      }
      BDChatSDK.setUserName(name)
      result(nil)   
    case "setUserPhoneNo":
      guard let args = call.arguments as? [String: Any],
        let phoneNo = args["phoneNo"] as? String
      else {
        return
      }
      BDChatSDK.setUserPhoneNo(phoneNo)
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
      if let args = call.arguments as? [String: Any] {
        let converted = convertToAnyHashable(args)
        let isFromSDK = BDSupportSDK.isFromMobileSDK(userInfo: converted)
        result(isFromSDK)
       } 
       else {
            result(false) // return false if no arguments
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
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
