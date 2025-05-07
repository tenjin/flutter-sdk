import Flutter
import UIKit
import AppTrackingTransparency

public class TenjinSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tenjin_plugin", binaryMessenger: registrar.messenger())
        let instance = TenjinSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init": initialize(call, result)
        case "optIn": optIn(call, result)
        case "optOut": optOut(call, result)
        case "optInParams": optInParams(call, result)
        case "optOutParams": optOutParams(call, result)
        case "optInOutUsingCMP": optInOutUsingCMP(call, result)
        case "optOutGoogleDMA": optOutGoogleDMA(call, result)
        case "optInGoogleDMA": optInGoogleDMA(call, result)
        case "connect": connect(call, result)
        case "transaction": transaction(call, result)
        case "transactionWithReceipt": transactionWithReceipt(call, result)
        case "eventWithName": eventWithName(call, result)
        case "eventWithNameAndValue": eventWithNameAndValue(call, result)
        case "appendAppSubversion": appendAppSubversion(call, result)
        case "requestTrackingAuthorization": requestTrackingAuthorization(call, result)
        case "registerAppForAdNetworkAttribution": registerAppForAdNetworkAttribution(call, result)
        case "updatePostbackConversionValue": updatePostbackConversionValue(call, result)
        case "updatePostbackConversionValueCoarseValue": updatePostbackConversionValueCoarseValue(call, result)
        case "updatePostbackConversionValueCoarseValueLockWindow": updatePostbackConversionValueCoarseValueLockWindow(call, result)
        case "getAttributionInfo": getAttributionInfo(call, result)
        case "setCustomerUserId": setCustomerUserId(call, result)
        case "getCustomerUserId": getCustomerUserId(call, result)
        case "setCacheEventSetting": setCacheEventSetting(call, result)
        case "setEncryptRequestsSetting": setEncryptRequestsSetting(call, result)
        case "getAnalyticsInstallationId": getAnalyticsInstallationId(call, result)
        case "setGoogleDMAParameters": setGoogleDMAParameters(call, result)
        case "eventAdImpressionAdMob": eventAdImpressionAdMob(call, result)
        case "eventAdImpressionAppLovin": eventAdImpressionAppLovin(call, result)
        case "eventAdImpressionHyperBid": eventAdImpressionHyperBid(call, result)
        case "eventAdImpressionIronSource": eventAdImpressionIronSource(call, result)
        case "eventAdImpressionTopOn": eventAdImpressionTopOn(call, result)
        case "eventAdImpressionTradPlus": eventAdImpressionTradPlus(call, result)
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func initialize(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let apiKey = args["apiKey"] as? String {
            TenjinSDK.getInstance(apiKey)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'apiKey'", details: nil))
        }
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
        if let args = call.arguments as? [String: Any], let params = args["params"] as? [String] {
            TenjinSDK.opt(inParams: params)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'params'", details: nil))
        }
    }
    
    private func optOutParams(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let params = args["params"] as? [String] {
            TenjinSDK.optOutParams(params)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'params'", details: nil))
        }
    }

    private func optInOutUsingCMP(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        TenjinSDK.optInOutUsingCMP()
        result(nil)
    }

    private func optOutGoogleDMA(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        TenjinSDK.optOutGoogleDMA()
        result(nil)
    }

    private func optInGoogleDMA(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        TenjinSDK.optInGoogleDMA()
        result(nil)
    }
    
    private func connect(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        TenjinSDK.connect()
        result(nil)
    }
    
    private func transaction(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let productName = args["productName"] as? String, let currencyCode = args["currencyCode"] as? String, let quantity = args["quantity"] as? NSInteger, let unitPrice = args["unitPrice"] as? Double {
            let price = NSDecimalNumber(value: unitPrice)
            TenjinSDK.transaction(withProductName: productName, andCurrencyCode: currencyCode, andQuantity: quantity, andUnitPrice: price)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing transaction parameters", details: nil))
        }
    }
    
    private func transactionWithReceipt(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let productId = args["productId"] as? String, let currencyCode = args["currencyCode"] as? String, let quantity = args["quantity"] as? Int, let unitPrice = args["unitPrice"] as? NSNumber, let transactionId = args["transactionId"] as? String, let receipt = args["receipt"] as? String {
            let unitPriceDecimal = NSDecimalNumber(decimal: unitPrice.decimalValue)
            TenjinSDK.transaction(withProductName: productId, andCurrencyCode: currencyCode, andQuantity: quantity, andUnitPrice: unitPriceDecimal, andTransactionId: transactionId, andBase64Receipt: receipt)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing transaction parameters", details: nil))
        }
    }
    
    private func eventWithName(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let name = args["name"] as? String {
            TenjinSDK.sendEvent(withName: name)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'name'", details: nil))
        }
    }
    
    private func eventWithNameAndValue(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let name = args["name"] as? String, let value = args["value"] as? Int {
            TenjinSDK.sendEvent(withName: name, andValue: value)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'name' or 'value'", details: nil))
        }
    }
    
    private func appendAppSubversion(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let value = args["value"] as? NSNumber {
            TenjinSDK.appendAppSubversion(value)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'value'", details: nil))
        }
    }
    
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
    
    private func updatePostbackConversionValue(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let conversionValue = args["conversionValue"] as? Int32 {
            TenjinSDK.updatePostbackConversionValue(conversionValue)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'conversionValue'", details: nil))
        }
    }
    
    private func updatePostbackConversionValueCoarseValue(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let conversionValue = args["conversionValue"] as? Int32, let coarseValue = args["coarseValue"] as? String {
            TenjinSDK.updatePostbackConversionValue(conversionValue, coarseValue: coarseValue)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'conversionValue' or 'coarseValue'", details: nil))
        }
    }
    
    private func updatePostbackConversionValueCoarseValueLockWindow(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let conversionValue = args["conversionValue"] as? Int32, let coarseValue = args["coarseValue"] as? String, let lockWindow = args["lockWindow"] as? Bool {
            TenjinSDK.updatePostbackConversionValue(conversionValue, coarseValue: coarseValue, lockWindow: lockWindow)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'conversionValue', 'coarseValue', or 'lockWindow'", details: nil))
        }
    }
    
    private func getAttributionInfo(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        TenjinSDK.sharedInstance().getAttributionInfo { (attributionInfo, error) in
            if let error = error {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
            } else if let attributionInfo = attributionInfo {
                result(attributionInfo)
            }
        }
    }
    
    private func setCustomerUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let userId = args["userId"] as? String {
            TenjinSDK.setCustomerUserId(userId)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'userId'", details: nil))
        }
    }
    
    private func getCustomerUserId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let userId = TenjinSDK.getCustomerUserId() {
            result(userId)
        } else {
            result(FlutterError(code: "Error", message: "Failed to get 'userId'", details: nil))
        }
    }

    private func setCacheEventSetting(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let setting = args["setting"] as? Bool {
            TenjinSDK.setCacheEventSetting(setting)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'setting'", details: nil))
        }
    }

    private func setEncryptRequestsSetting(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let setting = args["setting"] as? Bool {
            TenjinSDK.setEncryptRequestsSetting(setting)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'setting'", details: nil))
        }
    }

    private func getAnalyticsInstallationId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let installationId = TenjinSDK.getAnalyticsInstallationId() {
            result(installationId)
        } else {
            result(FlutterError(code: "Error", message: "Failed to get 'analyticsInstallationId'", details: nil))
        }
    }

    private func setGoogleDMAParameters(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any], let adPersonalization = args["adPersonalization"] as? Bool, let adUserData = args["adUserData"] as? Bool {
            TenjinSDK.sharedInstance().setGoogleDMAParametersWithAdPersonalization(adPersonalization, adUserData: adUserData)
            result(nil)
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing parameters", details: nil))
        }
    }

    private func eventAdImpressionAdMob(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let json = call.arguments as? [String: Any] {
            do {
                let jsonString = try convertToJsonString(from: json)
                TenjinSDK.adMobImpression(fromJSON:jsonString)
                result(nil)
            } catch {
                result(FlutterError(code: "Error", message: error.localizedDescription, details: nil))
            }
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'json'", details: nil))
        }
    }

    private func eventAdImpressionAppLovin(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let json = call.arguments as? [String: Any] {
            do {
                let jsonString = try convertToJsonString(from: json)
                TenjinSDK.appLovinImpression(fromJSON:jsonString)
                result(nil)
            } catch {
                result(FlutterError(code: "Error", message: error.localizedDescription, details: nil))
            }
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'json'", details: nil))
        }
    }

    private func eventAdImpressionHyperBid(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let json = call.arguments as? [String: Any] {
            do {
                let jsonString = try convertToJsonString(from: json)
                TenjinSDK.hyperBidImpression(fromJSON:jsonString)
                result(nil)
            } catch {
                result(FlutterError(code: "Error", message: error.localizedDescription, details: nil))
            }
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'json'", details: nil))
        }
    }

    private func eventAdImpressionIronSource(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let json = call.arguments as? [String: Any] {
            do {
                let jsonString = try convertToJsonString(from: json)
                TenjinSDK.ironSourceImpression(fromJSON:jsonString)
                result(nil)
            } catch {
                result(FlutterError(code: "Error", message: error.localizedDescription, details: nil))
            }
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'json'", details: nil))
        }
    }

    private func eventAdImpressionTopOn(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let json = call.arguments as? [String: Any] {
            do {
                let jsonString = try convertToJsonString(from: json)
                TenjinSDK.topOnImpression(fromJSON:jsonString)
                result(nil)
            } catch {
                result(FlutterError(code: "Error", message: error.localizedDescription, details: nil))
            }
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'json'", details: nil))
        }
    }

    private func eventAdImpressionTradPlus(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let json = call.arguments as? [String: Any] {
            do {
                let jsonString = try convertToJsonString(from: json)
                TenjinSDK.tradPlusImpression(fromJSON:jsonString)
                result(nil)
            } catch {
                result(FlutterError(code: "Error", message: error.localizedDescription, details: nil))
            }
        } else {
            result(FlutterError(code: "Error", message: "Invalid or missing 'json'", details: nil))
        }
    }
    
    private func convertToJsonString(from dictionary: [String: Any]) throws -> String {
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
        guard let jsonString = String(data: jsonData, encoding: .utf8) else {
            throw NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not convert JSON data to String"])
        }
        return jsonString
    }
}
