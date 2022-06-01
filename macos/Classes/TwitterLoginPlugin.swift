import Cocoa
import FlutterMacOS

import SafariServices
import AuthenticationServices

public class TwitterLoginPlugin: NSObject, FlutterPlugin, ASWebAuthenticationPresentationContextProviding {
    var session: Any? = nil
    
    @available(macOS 10.15, *)
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return NSApplication.shared.mainWindow!
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "twitter_login/auth_browser", binaryMessenger: registrar.messenger)
        let instance = TwitterLoginPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "authentication":
            if #available(macOS 10.15, *) {
                authentication(call, result: result)
            } else {
                result(nil)
                return
            }
        default:
            result(nil)
            return
        }
    }
    
    
    @available(macOS 10.15, *)  //required by XCode or fail to compile
    public func authentication(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as! NSDictionary
        let url = args["url"] as! String
        let urlScheme = args["redirectURL"] as? String
        
        
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
            result(nil)
        }
        
    }
}
