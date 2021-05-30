import 'dart:io';

import 'package:flutter/services.dart';

class AuthBrowser {
  static const _channel = const MethodChannel('twitter_login/auth_browser');

  static Future<String> doAuth(String url, String scheme) async {
    String resultURI = '';
    if (Platform.isIOS) {
      resultURI = await _channel.invokeMethod('authentication', {
        'url': url,
        'redirectURL': scheme,
      });
    }

    return resultURI;
  }
}
