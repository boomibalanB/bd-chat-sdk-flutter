package com.syncfusion.bolddeskchatsdk.bd_chat_sdk

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.syncfusion.bolddeskandroidchatSDK.BoldDeskChatSDK
import com.syncfusion.bolddeskandroidchatSDK.R
import androidx.core.graphics.drawable.IconCompat
import android.graphics.Bitmap
import android.graphics.BitmapFactory

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
            val culture = call.argument<String>("culture") ?: "en-US"
            try {
                BoldDeskChatSDK.configure(context, appKey, brandUrl, culture)
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
        } else if (call.method == "setPrefillFields") {
            val name = call.argument<String>("name") ?: ""
            val email = call.argument<String>("email") ?: ""
            val phoneNumber = call.argument<String>("phoneNumber") ?: ""
            val chatFields = call.argument<Map<String, Any>>("chatFields")
            
            // Normalize: Convert Double to Int for whole numbers (both in arrays and standalone values)
            val normalizedChatFields = chatFields?.mapValues { entry ->
                when (val value = entry.value) {
                    is List<*> -> {
                        value.map { item ->
                            when (item) {
                                is Double -> if (item == item.toLong().toDouble()) item.toInt() else item
                                is Float -> if (item == item.toLong().toFloat()) item.toInt() else item
                                is Number -> {
                                    val n = item.toDouble()
                                    if (n == n.toLong().toDouble()) n.toInt() else n
                                }
                                else -> item
                            }
                        }
                    }
                    is Double -> if (value == value.toLong().toDouble()) value.toInt() else value
                    is Float -> if (value == value.toLong().toFloat()) value.toInt() else value
                    else -> value
                }
            }
            
            try {
                BoldDeskChatSDK.setPrefillFields(name, email, phoneNumber, normalizedChatFields)
                result.success("Prefill Fields Set Successfully")
            } catch (e: Exception) {
                result.error("PREFILL_FIELDS_FAILED", e.message, null)
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
            BoldDeskChatSDK.disablePushNotification()
            result.success(null)
        } else if (call.method == "handlePushNotifications") {
            val messageData = call.argument<Map<String, String>>("body") ?: emptyMap()
            val iconBytes = call.argument<ByteArray>("notificationIcon") ?: "".toByteArray()
            val bitmap = BitmapFactory.decodeByteArray(iconBytes, 0, iconBytes.size)
            val iconCompact = IconCompat.createWithBitmap(bitmap)
            try {
                BoldDeskChatSDK.handlePushNotifications(context, messageData, iconCompact)
                result.success("Notification shown Successfully")
            } catch (e: Exception) {
                result.error("NOTIFICATION_FAILED", e.message, null)
            }
        } else if (call.method == "applyTheme") {
            val appBarColor  = call.argument<String>("appbarColor") ?: ""
            val accentColor = call.argument<String>("accentColor") ?: ""
            val backgroundColor = call.argument<String>("backgroundColor") ?: ""
            val stickyButtonColor = call.argument<String>("stickyButtonColor") ?: ""
            BoldDeskChatSDK.applyTheme(context, appBarColor , accentColor, backgroundColor, stickyButtonColor)
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
