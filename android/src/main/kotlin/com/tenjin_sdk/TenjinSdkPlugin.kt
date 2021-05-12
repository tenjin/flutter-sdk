package com.tenjin_sdk

import android.content.Context
import androidx.annotation.NonNull
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
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tenjin_sdk")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "init" -> {
        init(call, result)
      }
      "optIn" -> {
        optIn(call, result)
      }
      "optOut" -> {
        optOut(call, result)
      }
      "optInParams" -> {
        optInParams(call, result)
      }
      "optOutParams" -> {
        optOutParams(call, result)
      }
      "connect" -> {
        connect(call, result)
      }
      "transaction" -> {
        transaction(call, result)
      }
      "eventWithName" -> {
        eventWithName(call, result)
      }
      "eventWithNameAndValue" -> {
        eventWithNameAndValue(call, result)
      }
      "appendAppSubversion" -> {
        appendAppSubversion(call, result)
      }
      "requestTrackingAuthorization" -> {
        result.success(true)
      }
      "registerAppForAdNetworkAttribution" -> {
        result.success(null)
      }
      "updateConversionValue" -> {
        result.success(null)
      }
        else -> {
          result.notImplemented()
        }
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

  fun transaction(call: MethodCall, result: Result) {
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
}
