import Flutter
import UIKit
import AppTrackingTransparency

public class SwiftTenjinSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tenjin_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftTenjinSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init": initialize(call, result)
        case "optIn": optIn(call, result)
        case "optOut": optOut(call, result)
        case "optInParams": optInParams(call, result)
        case "optOutParams": optOutParams(call, result)
        case "connect": connect(call, result)
        case "transaction": transaction(call, result)
        case "eventWithName": eventWithName(call, result)
        case "eventWithNameAndValue": eventWithNameAndValue(call, result)
        case "appendAppSubversion": appendAppSubversion(call, result)
        case "requestTrackingAuthorization": requestTrackingAuthorization(call, result)
        case "registerAppForAdNetworkAttribution": registerAppForAdNetworkAttribution(call, result)
        case "updateConversionValue": updateConversionValue(call, result)
        default: result(FlutterMethodNotImplemented)
        }
    }

    private func initialize(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      let args = call.arguments as! [String: Any]
      let apiKey = args["apiKey"] as! String
      TenjinSDK.getInstance(apiKey)
      result(nil)
    }

    private func optIn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      TenjinSDK.optIn()
      result(nil)
    }

    private func optOut(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      TenjinSDK.optOut()
      result(nil)
    }

    private func optInParams(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      let args = call.arguments as! [String: Any]
      let params = args["params"] as! [String]
      TenjinSDK.opt(inParams: params)
      result(nil)
    }

    private func optOutParams(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      let args = call.arguments as! [String: Any]
      let params = args["params"] as! [String]
      TenjinSDK.optOutParams(params)
      result(nil)
    }

    private func connect(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      TenjinSDK.connect()
      // TenjinSDK.registerDeepLinkHandler({ s1: [AnyHashable : Any]?, s2: Error -> Bool in
      //   result(nil)
      //   return false
      // })
      result(nil)
    }

    private func transaction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      let args = call.arguments as! [String: Any]
      let productId = args["productId"] as! String
      let currencyCode = args["currencyCode"] as! String
      let quantity = args["quantity"] as! Int
      let unitPrice = args["unitPrice"] as! NSNumber
      let unitPriceDecimal = NSDecimalNumber(decimal: unitPrice.decimalValue)
      let transactionId = args["transactionId"] as! String
      let receipt = args["receipt"] as! String
      TenjinSDK.transaction(withProductName: productId, andCurrencyCode: currencyCode, andQuantity: quantity, andUnitPrice: unitPriceDecimal, andTransactionId: transactionId, andBase64Receipt: receipt)
      result(nil)
    }

    private func eventWithName(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      let args = call.arguments as! [String: Any]
      let name = args["name"] as! String
      TenjinSDK.sendEvent(withName: name)
      result(nil)
    }

    private func eventWithNameAndValue(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      let args = call.arguments as! [String: Any]
      let name = args["name"] as! String
      let value = args["value"] as! Int
      TenjinSDK.sendEvent(withName: name, andEventValue: String(value))
      result(nil)
    }

    private func appendAppSubversion(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
      let args = call.arguments as! [String: Any]
      let value = args["value"] as! NSNumber
      TenjinSDK.appendAppSubversion(value)
      result(nil)
    }

    //! Tracking Authorization
    private func requestTrackingAuthorization(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                result(status == ATTrackingManager.AuthorizationStatus.authorized)
            })
        }
        else {
          result(true)
        }
    }

    private func registerAppForAdNetworkAttribution(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        TenjinSDK.registerAppForAdNetworkAttribution()
        result(nil)
    }

    private func updateConversionValue(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        let args = call.arguments as! [String: Any]
        let value = args["value"] as! NSNumber
        TenjinSDK.updateConversionValue(value)
        result(nil)
    }
}

/*
https://stackoverflow.com/questions/24002369/how-do-i-call-objective-c-code-from-swift
*/