import Flutter
import UIKit
import SafariServices
import AuthenticationServices

public class SwiftTwitterLoginPlugin: NSObject, FlutterPlugin {
    var session: Any? = nil
    private var registrar: FlutterPluginRegistrar?
    private var presentationContext: Any?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "twitter_login/auth_browser",
            binaryMessenger: registrar.messenger()
        )
        let instance = SwiftTwitterLoginPlugin()
        instance.registrar = registrar
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
            guard session == nil else {
                result(FlutterError(code: "authentication_in_progress",
                                    message: "An authentication session is already in progress.",
                                    details: nil))
                return
            }

            if #available(iOS 13.0, *) {
                // Resolve the window at login time: implicit engines can register
                // plugins before their Flutter view is attached to a scene.
                guard let window = registrar?.viewController?.viewIfLoaded?.window else {
                    result(FlutterError(code: "no_presentation_anchor",
                                        message: "No Flutter window is available for authentication.",
                                        details: nil))
                    return
                }
                presentationContext = AuthenticationPresentationContext(window: window)
            }

            var completed = false
            let finish: (String?, FlutterError?) -> Void = { callbackURL, error in
                guard !completed else { return }
                completed = true
                self.session = nil
                self.presentationContext = nil
                if let error = error {
                    result(error)
                } else {
                    result(callbackURL)
                }
            }
            let authSession = ASWebAuthenticationSession(
                url: URL(string: url)!,
                callbackURLScheme: urlScheme
            ) { url, _ in
                finish(url?.absoluteString, nil)
            }
            self.session = authSession
            if #available(iOS 13.0, *) {
                authSession.presentationContextProvider =
                    presentationContext as? AuthenticationPresentationContext
            }
            if !authSession.start() {
                finish(nil, FlutterError(code: "authentication_start_failed",
                                         message: "Unable to start authentication.",
                                         details: nil))
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
}

@available(iOS 13.0, *)
private final class AuthenticationPresentationContext: NSObject,
    ASWebAuthenticationPresentationContextProviding {
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        super.init()
    }

    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return window
    }
}
