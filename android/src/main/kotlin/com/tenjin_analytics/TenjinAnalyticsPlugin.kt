package com.tenjin_analytics

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Context

import com.tenjin.android.TenjinSDK

class TenjinAnalyticsPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private lateinit var instance : TenjinSDK

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tenjin_analytics")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "connect") {
      connect(call, result)
    } else if (call.method == "sendPurchaseEvent") {
      sendPurchaseEvent(call, result)
    } else if (call.method == "sendCustomEvent") {
      sendCustomEvent(call, result)
    } else if (call.method == "sendCustomEventWithValue") {
      sendCustomEventWithValue(call, result)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  fun connect(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val apiKey = args["apiKey"] as String
    instance = TenjinSDK.getInstance(context, apiKey)
    val userOptIn: Boolean = checkOptInValue()
    if (userOptIn) {
      instance.optIn()
    } else {
      instance.optOut()
    }
    instance.connect()
    result.success(null)
  }

  protected fun checkOptInValue(): Boolean {
    return true
  }

  fun sendPurchaseEvent(call: MethodCall, result: Result) {
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

  fun sendCustomEvent(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val name = args["name"] as String
    instance.eventWithName(name)
    result.success(null)
  }

  fun sendCustomEventWithValue(call: MethodCall, result: Result){
    val args = call.arguments as Map<*, *>
    val name = args["name"] as String
    val value = args["value"] as String
    instance.eventWithNameAndValue(name, value)
    result.success(null)
  }
}
