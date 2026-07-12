import Flutter
import UIKit
import SafariServices
import AuthenticationServices

public class SwiftTwitterLoginPlugin: NSObject, FlutterPlugin, ASWebAuthenticationPresentationContextProviding {
    var session: Any?

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
        }
    }

    public func authentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let args = call.arguments as? NSDictionary,
            let urlString = args["url"] as? String,
            let url = URL(string: urlString)
        else {
            result(nil)
            return
        }
        let urlScheme = args["redirectURL"] as? String

        if #available(iOS 12.0, *) {
            var authSession: ASWebAuthenticationSession?
            authSession = ASWebAuthenticationSession(
                url: url,
                callbackURLScheme: urlScheme
            ) { url, error in
                result(url?.absoluteString)
                authSession?.cancel()
                self.session = nil
            }
            self.session = authSession
            if #available(iOS 13.0, *) {
                authSession?.presentationContextProvider = self
            }
            if authSession?.start() != true {
                result(nil)
            }
        } else if #available(iOS 11.0, *) {
            var authSession: SFAuthenticationSession?
            authSession = SFAuthenticationSession(
                url: url,
                callbackURLScheme: urlScheme
            ) { url, error in
                result(url?.absoluteString)
                authSession?.cancel()
                self.session = nil
            }
            self.session = authSession
            if authSession?.start() != true {
                result(nil)
            }
        } else {
            result("")
        }
    }

    @available(iOS 12.0, *)
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow } ?? UIWindow()
        }
        return UIApplication.shared.keyWindow ?? UIWindow()
    }
}
