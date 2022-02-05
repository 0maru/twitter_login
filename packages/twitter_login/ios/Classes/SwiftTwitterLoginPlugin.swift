import Flutter
import UIKit
import SafariServices
import AuthenticationServices

public class SwiftTwitterLoginPlugin: NSObject, FlutterPlugin, ASWebAuthenticationPresentationContextProviding  {
    var session: Any? = nil

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "twitter_login/auth_browser",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftTwitterLoginPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "authentication":
                authentication(call, result: result)
            default:
                result(nil)
                return
        }
    }

    public func authentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! NSDictionary
        let url = args["url"] as! String
        let urlScheme = args["redirectURL"] as? String
        
        // iOS12以降
        if #available(iOS 12.0, *) {
            var authSession: ASWebAuthenticationSession?
            authSession = ASWebAuthenticationSession(
                url: URL(string: url)!,
                callbackURLScheme: urlScheme
            ) { url, error in
                result(url?.absoluteString)
                authSession!.cancel()
                self.session = nil
            }
            self.session = authSession
            if #available(iOS 13.0, *) {
                authSession?.presentationContextProvider = self
            }
            if !authSession!.start() {
            // TODO: failed
            }
        // iOS11のみ
        } else if #available(iOS 11.0, *) {
            var authSession: SFAuthenticationSession?
            authSession = SFAuthenticationSession(
                url: URL(string: url)!,
                callbackURLScheme: urlScheme
            ) { url, error in
                result(url?.absoluteString)
                authSession!.cancel()
                self.session = nil
            }
            self.session = authSession
            if !authSession!.start() {
            // TODO: failed
            }
        } else {
            // iOS10以前は未対応
            result("")
            return
        }
    }
    
    @available(iOS 12.0, *)
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.delegate!.window!!
    }
}
