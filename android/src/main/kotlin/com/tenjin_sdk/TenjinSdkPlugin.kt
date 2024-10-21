package com.tenjin_sdk

import android.content.Context
import androidx.annotation.NonNull
import org.json.JSONObject
import com.tenjin.android.Callback
import com.tenjin.android.TenjinSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


class TenjinSdkPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private lateinit var instance : TenjinSDK

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tenjin_plugin")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
      when (call.method) {
          "init" -> init(call, result)
          "optIn" -> optIn(call, result)
          "optOut" -> optOut(call, result)
          "optInParams" -> optInParams(call, result)
          "optOutParams" -> optOutParams(call, result)
          "optInOutUsingCMP" -> optInOutUsingCMP(call, result)
          "optOutGoogleDMA" -> optOutGoogleDMA(call, result)
          "optInGoogleDMA" -> optInGoogleDMA(call, result)
          "connect" -> connect(call, result)
          "transaction" -> transaction(call, result)
          "transactionWithReceipt" -> transactionWithReceipt(call, result)
          "eventWithName" -> eventWithName(call, result)
          "eventWithNameAndValue" -> eventWithNameAndValue(call, result)
          "appendAppSubversion" -> appendAppSubversion(call, result)
          "requestTrackingAuthorization" -> result.success(true)
          "registerAppForAdNetworkAttribution" -> result.success(null)
          "getAttributionInfo" -> getAttributionInfo(call, result)
          "setCustomerUserId" -> setCustomerUserId(call, result)
          "getCustomerUserId" -> getCustomerUserId(call, result)
          "setCacheEventSetting" -> setCacheEventSetting(call, result)
          "getAnalyticsInstallationId" -> getAnalyticsInstallationId(call, result)
        "setGoogleDMAParameters" -> setGoogleDMAParameters(call, result)
          "eventAdImpressionAdMob" -> eventAdImpressionAdMob(call.arguments as HashMap<String, Any>)
          "eventAdImpressionAppLovin" -> eventAdImpressionAppLovin(call.arguments as HashMap<String, Any>)
          "eventAdImpressionHyperBid" -> eventAdImpressionHyperBid(call.arguments as HashMap<String, Any>)
          "eventAdImpressionIronSource" -> eventAdImpressionIronSource(call.arguments as HashMap<String, Any>)
          "eventAdImpressionTopOn" -> eventAdImpressionTopOn(call.arguments as HashMap<String, Any>)
          "eventAdImpressionTradPlus" -> eventAdImpressionTradPlus(call.arguments as HashMap<String, Any>)
          else -> result.notImplemented()
      }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun init(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val apiKey = args["apiKey"] as String
    instance = TenjinSDK.getInstance(context, apiKey)
    result.success(null)
  }

  fun connect(call: MethodCall, result: Result){
    instance.connect()
    instance.getDeeplink { clickedTenjinLink, isFirstSession, data ->
      channel.invokeMethod("onSucessDeeplink", mapOf(
        "clickedTenjinLink" to clickedTenjinLink,
        "isFirstSession" to isFirstSession,
        "data" to data
      ));
    }
    result.success(null)
  }


  fun optIn(call: MethodCall, result: Result){
    instance.optIn()
    result.success(null)
  }

  fun optOut(call: MethodCall, result: Result){
    instance.optOut()
    result.success(null)
  }

  fun optInParams(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val params = args["params"] as List<String>
    instance.optInParams(params.toTypedArray())
    result.success(null)
  }

  fun optOutParams(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val params = args["params"] as List<String>
    instance.optOutParams(params.toTypedArray())
    result.success(null)
  }

  fun optInOutUsingCMP(call: MethodCall, result: Result){
    instance.optInOutUsingCMP()
    result.success(null)
  }
  
  fun optOutGoogleDMA(call: MethodCall, result: Result){
    instance.optOutGoogleDMA()
    result.success(null)
  }

  fun optInGoogleDMA(call: MethodCall, result: Result){
    instance.optInGoogleDMA()
    result.success(null)
  }

  fun setGoogleDMAParameters(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val adPersonalization = args["adPersonalization"] as Boolean
    val adUserData = args["adUserData"] as Boolean
    instance.setGoogleDMAParameters(adPersonalization, adUserData)
    result.success(null)
  }

  fun transaction(call: MethodCall, result: Result) {
    val args = call.arguments as Map<*, *>
    val productName = args["productName"] as String
    val currencyCode = args["currencyCode"] as String
    val quantity = args["quantity"] as Double
    val unitPrice = args["unitPrice"] as Double
    instance.transaction(productName, currencyCode, quantity.toInt(), unitPrice)
    result.success(null)
  }

  fun transactionWithReceipt(call: MethodCall, result: Result) {
    val args = call.arguments as Map<*, *>
    val productId = args["productId"] as String
    val purchaseData = args["purchaseData"] as String
    val dataSignature = args["dataSignature"] as String
    val currencyCode = args["currencyCode"] as String
    val unitPrice = args["unitPrice"] as Double
    val quantity = args["quantity"] as Integer
    instance.transaction(productId, currencyCode, quantity.toInt(), unitPrice, purchaseData, dataSignature)
    result.success(null)
  }

  fun eventWithName(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val name = args["name"] as String
    instance.eventWithName(name)
    result.success(null)
  }

  fun eventWithNameAndValue(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val name = args["name"] as String
    val value = args["value"] as Integer
    instance.eventWithNameAndValue(name, value.toInt())
    result.success(null)
  }

  fun appendAppSubversion(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val value = args["value"] as Integer
    instance.appendAppSubversion(value.toInt())
    result.success(null)
  }

  fun getAttributionInfo(call: MethodCall, result: Result) {
    var hasResponded = false
    instance.getAttributionInfo { attributionInfo ->
      if (!hasResponded) {
        hasResponded = true
        if (attributionInfo != null) {
          result.success(attributionInfo)
        } else {
          result.error("Error", "Attribution info is null", null)
        }
      }
    }
  }

  private fun setCustomerUserId(call: MethodCall, result: Result) {
    val userId = call.argument<String>("userId")
    if (userId != null) {
      instance.setCustomerUserId(userId)
      result.success(null)
    } else {
      result.error("Error", "Invalid or missing 'userId'", null)
    }
  }

  private fun getCustomerUserId(call: MethodCall, result: Result) {
    val userId = instance.getCustomerUserId()
    if (userId != null) {
      result.success(userId)
    } else {
      result.error("Error", "Failed to get 'userId'", null)
    }
  }

  private fun setCacheEventSetting(call: MethodCall, result: Result) {
    val setting = call.argument<Boolean>("setting")
    if (setting != null) {
      instance.setCacheEventSetting(setting)
      result.success(null)
    } else {
      result.error("Error", "Invalid or missing 'setting'", null)
    }
  }

  private fun getAnalyticsInstallationId(call: MethodCall, result: Result) {
    val installationId = instance.getAnalyticsInstallationId()
    if (installationId != null) {
      result.success(installationId)
    } else {
      result.error("Error", "Failed to get 'analyticsInstallationId'", null)
    }
  }

  private fun eventAdImpressionAdMob(json: HashMap<String, Any>) {
    try {
      instance.eventAdImpressionAdMob((json as Map<*, *>?)?.let { JSONObject(it) })
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  private fun eventAdImpressionAppLovin(json: HashMap<String, Any>) {
    try {
      instance.eventAdImpressionAppLovin((json as Map<*, *>?)?.let { JSONObject(it) })
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  private fun eventAdImpressionHyperBid(json: HashMap<String, Any>) {
    try {
      instance.eventAdImpressionHyperBid((json as Map<*, *>?)?.let { JSONObject(it) })
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  private fun eventAdImpressionIronSource(json: HashMap<String, Any>) {
    try {
      instance.eventAdImpressionIronSource((json as Map<*, *>?)?.let { JSONObject(it) })
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  private fun eventAdImpressionTopOn(json: HashMap<String, Any>) {
    try {
      instance.eventAdImpressionTopOn((json as Map<*, *>?)?.let { JSONObject(it) })
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }

  private fun eventAdImpressionTradPlus(json: HashMap<String, Any>) {
    try {
      instance.eventAdImpressionTradPlus((json as Map<*, *>?)?.let { JSONObject(it) })
    } catch (e: Exception) {
      e.printStackTrace()
    }
  }
}
