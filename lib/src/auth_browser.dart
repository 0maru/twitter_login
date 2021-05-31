import 'package:flutter/services.dart';

class AuthBrowser {
  static const _channel = const MethodChannel('twitter_login/auth_browser');

  static Future<String> doAuth(String url, String scheme) async {
    return await _channel.invokeMethod('authentication', {
      'url': url,
      'redirectURL': scheme,
    });
  }
}
