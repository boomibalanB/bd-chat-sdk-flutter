package com.syncfusion.bolddeskchatsdk.bd_chat_sdk

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.syncfusion.bolddeskandroidchatSDK.BoldDeskChatSDK
import com.syncfusion.bolddeskandroidchatSDK.R

/** BdChatSdkPlugin */
class BdChatSdkPlugin : FlutterPlugin, MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bd_chat_sdk")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall,result: Result ) {
        if (call.method == "configure") {
            val appKey = call.argument<String>("appKey") ?: ""
            val brandUrl = call.argument<String>("brandUrl") ?: ""
            try {
                BoldDeskChatSDK.configure(context, appKey, brandUrl)
            } catch (e: Exception) {
                result.error("INITIALIZATION_FAILED", e.message, null)
            }
        } else if (call.method == "showChat") {
            try {
                BoldDeskChatSDK.showChat(context)
                result.success("Chat Shown Successfully")
            } catch (e: Exception) {
                result.error("SHOW_CHAT_FAILED", e.message, null)
            }
        } else if (call.method == "closeChat") {
            try {
                BoldDeskChatSDK.closeChat(context)
                result.success("Chat Close Successfully")
            } catch (e: Exception) {
                result.error("CLOS_ECHAT_FAILED", e.message, null)
            }
        } else if (call.method == "clearSession") {
            try {
                BoldDeskChatSDK.clearSession()
                result.success("Clear Session Successfully")
            } catch (e: Exception) {
                result.error("CLEAR_SESSION_FAILED", e.message, null)
            }
        } else if (call.method == "enableLogging") {
            try {
                BoldDeskChatSDK.enableLogging()
                result.success("Enable Logging Successfully")
            } catch (e: Exception) {
                result.error("Enable_Logging_FAILED", e.message, null)
            }
        } else if (call.method == "setUserEmail") {
            val email = call.argument<String>("email") ?: ""
            try {
                BoldDeskChatSDK.setUserEmail(email)
                result.success("Email Set Successfully")
            } catch (e: Exception) {
                result.error("EMAIL_SET_FAILED", e.message, null)
            }
        } else if (call.method == "setUserName") {
            val name = call.argument<String>("name") ?: ""
            try {
                BoldDeskChatSDK.setUserName(name)
                result.success("Name Set Successfully")
            } catch (e: Exception) {
                result.error("NAME_SET_FAILED", e.message, null)
            }
        } else if (call.method == "setUserPhoneNo") {
            val phoneNo = call.argument<String>("phoneNo") ?: ""
            try {
                BoldDeskChatSDK.setUserPhoneNo(phoneNo)
                result.success("PhoneNo Set Successfully")
            } catch (e: Exception) {
                result.error("PHONENO_SET_FAILED", e.message, null)
            }
        } else if (call.method == "setUserToken") {
            val userToken = call.argument<String>("userToken") ?: ""
            try {
                BoldDeskChatSDK.setUserToken(userToken)
                result.success("UserToken Set Successfully")
            } catch (e: Exception) {
                result.error("USERTOKEN_SET_FAILED", e.message, null)
            }
        } else if (call.method == "setPreferredTheme") {
            val themeString = call.argument<String>("theme")?.lowercase() ?: ""
            val preferredTheme = when (themeString) {
                "light" -> BoldDeskChatSDK.SDKTheme.LIGHT
                "dark" -> BoldDeskChatSDK.SDKTheme.DARK
                else -> BoldDeskChatSDK.SDKTheme.SYSTEM
            }
            try {
                BoldDeskChatSDK.setPreferredTheme(preferredTheme)
                result.success("Theme Set Successfully")
            } catch (e: Exception) {
                result.error("THEME_SET_FAILED", e.message, null)
            }
        } else if (call.method == "applyCustomFontFamilyInAndroid") {
            val regular = call.argument<String>("regular") ?: ""
            val medium = call.argument<String>("medium") ?: ""
            val semiBold = call.argument<String>("semiBold") ?: ""
            val bold = call.argument<String>("bold") ?: ""
            try {
                // Dynamically find the resource ID for each font name
                val regularId = getFontResourceId(context, regular)
                val mediumId = getFontResourceId(context, medium)
                val semiBoldId = getFontResourceId(context, semiBold)
                val boldId = getFontResourceId(context, bold)
                BoldDeskChatSDK.applyCustomFontFamily(
                    regular = regularId,
                    medium = mediumId,
                    semiBold = semiBoldId,
                    bold = boldId
                )
                result.success(null)
            } catch (e: Exception) {
                result.error("FONT_NOT_FOUND", e.message, null)
            }
        } else if (call.method == "isFromChatSDK") {
            val messageData = call.argument<Map<String, String>>("messageData") ?: emptyMap()
            val isFromChatSDK = BoldDeskChatSDK.isFromChatSDK(messageData)
            result.success(isFromChatSDK)
        } else if (call.method == "enablePushNotification") {
            val fcmToken = call.argument<String>("fcmToken") ?: ""
            BoldDeskChatSDK.enablePushNotification(fcmToken)
            result.success(null)
        } else if (call.method == "disablePushNotification") {
            val fcmToken = call.argument<String>("fcmToken") ?: ""
            BoldDeskChatSDK.disablePushNotification(fcmToken)
            result.success(null)
        } else if (call.method == "handlePushNotifications") {
            val messageData = call.argument<Map<String, String>>("body") ?: emptyMap()
            val icon = call.argument<String>("icon") ?: ""
            val iconResId = resolveIcon(context, icon)
            try {
                BoldDeskChatSDK.handlePushNotifications(context, messageData, iconResId)
                result.success("Notification shown Successfully")
            } catch (e: Exception) {
                result.error("NOTIFICATION_FAILED", e.message, null)
            }
        } else if (call.method == "applyTheme") {
            val appBarColor  = call.argument<String>("appbarColor") ?: ""
            val accentColor = call.argument<String>("accentColor") ?: ""
            val backgroundColor = call.argument<String>("backgroundColor") ?: ""
            val stickyButtonColor = call.argument<String>("stickyButtonColor") ?: ""
            BoldDeskChatSDK.applyTheme(appBarColor , accentColor, backgroundColor, stickyButtonColor)
            result.success("Theme applied Successfully")
        } else if (call.method == "setSystemFontSize"){
            val isEnabled = call.argument<Boolean>("enable") ?: false
            BoldDeskChatSDK.setSystemFontSize(isEnabled)
            result.success("Logging set Successfully")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun getFontResourceId(context: Context, fontName: String): Int {
        // This is the magic: It looks for a resource of type "font" with the given name
        // in the application's package.
        val resourceId = context.resources.getIdentifier(fontName, "font", context.packageName)

        if (resourceId == 0) {
            // This error is critical for debugging!
            throw Exception("Font resource '$fontName' not found. " +
                    "Ensure it's in pubspec.yaml and the filename is correct.")
        }
        return resourceId
    }

    private fun resolveIcon(context: Context, iconName: String): Int {
        // Try to resolve from drawable resources
        val resId = context.resources.getIdentifier(
            iconName,
            "drawable",
            context.packageName
        )

        // Return resolved ID or default launcher icon
        return if (resId != 0) resId else android.R.drawable.ic_dialog_info
    }
}
