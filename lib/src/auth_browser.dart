import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:twitter_login/src/utils.dart';

const String methodName = 'twitter_login/auth_browser';

class AuthBrowser {
  late final String id;
  static const _channel = const MethodChannel(methodName);
  late MethodChannel _methodCallHandlerChannel;
  bool _isOpen = false;
  VoidCallback onClose;

  AuthBrowser({required this.onClose}) {
    id = createCryptoRandomString();
    _methodCallHandlerChannel = MethodChannel('${methodName}_$id');
    _methodCallHandlerChannel.setMethodCallHandler(methodCallHandler);
    _isOpen = false;
  }

  Future methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onClose":
        onClose();
        _isOpen = false;
        break;
      default:
        throw PlatformException(code: '');
    }
  }

  Future<String> doAuth(String url, String scheme) async {
    if (_isOpen) {
      throw PlatformException(code: 'custom_browser is opened.');
    }

    _isOpen = true;
    final token = await _channel.invokeMethod('open', {
      'url': url,
      'redirectURL': scheme,
      'id': id,
    });
    return token;
  }

  Future<void> open(String url, String scheme) async {
    if (_isOpen) {
      throw PlatformException(code: 'custom_browser is opened.');
    }

    _isOpen = true;
    await _channel.invokeMethod('open', {
      'url': url,
      'redirectURL': scheme,
      'id': id,
    });
  }
}
