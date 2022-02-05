import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const MethodChannel _channel = MethodChannel('twitter_login/auth_browser');

abstract class MethodChannelTwitterLogin extends PlatformInterface {
  MethodChannelTwitterLogin() : super(token: _token);

  static final Object _token = Object();

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
