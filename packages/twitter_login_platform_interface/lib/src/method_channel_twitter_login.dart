import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const MethodChannel _channel = MethodChannel('twitter_login/auth_browser');

abstract class MethodChannelTwitterLogin extends PlatformInterface {
  MethodChannelTwitterLogin() : super(token: _token);

  @visibleForTesting
  MethodChannel get channel => _channel;

  static final Object _token = Object();

  Future<void> setScheme(String scheme) async {
    try {
      if (!Platform.isAndroid) {
        return;
      }

      await _channel.invokeMethod('setScheme', {'scheme': scheme});
    } on PlatformException {
      rethrow;
    }
  }

  // ignore: public_member_api_doc
  Future<void> open(String url, String scheme) async {
    await _channel.invokeMethod('open', {
      'url': url,
      'redirectURL': scheme,
    });
  }

  // ignore: public_member_api_doc
  Future<String?> doAuth(String url, String scheme) {
    return _channel.invokeMethod<String>('authentication', {
      'url': url,
      'redirectURL': scheme,
    });
  }
}
