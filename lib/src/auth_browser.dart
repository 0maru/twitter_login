import 'dart:io';

import 'package:flutter/services.dart';
import 'package:twitter_login/src/exception.dart';
import 'package:twitter_login/src/utils.dart';

const String methodName = 'twitter_login/auth_browser';

class AuthBrowser {
  AuthBrowser({required this.onClose}) {
    id = createCryptoRandomString();
    _methodCallHandlerChannel = MethodChannel('${methodName}_$id');
    _methodCallHandlerChannel.setMethodCallHandler(methodCallHandler);
    _isOpen = false;
  }
  late final String id;
  static const _channel = MethodChannel(methodName);
  late MethodChannel _methodCallHandlerChannel;
  bool _isOpen = false;
  void Function() onClose;

  Future<void> methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'onClose':
        onClose();
        _isOpen = false;
        break;
      default:
        return;
    }
  }

  ///　Open a web browser and log in to your Twitter account.
  Future<String?> doAuth(String url, String scheme) async {
    if (Platform.isAndroid) {
      return '';
    }
    if (_isOpen) {
      throw PlatformException(code: 'AuthBrowser is opened.');
    }

    _isOpen = true;
    final token = await _channel.invokeMethod<String>('authentication', {
      'url': url,
      'redirectURL': scheme,
      'id': id,
    });

    if (token == null) {
      throw const CanceledByUserException();
    }

    _isOpen = false;
    return token;
  }

  ///　Open a web browser and log in to your Twitter account.
  Future<bool> open(String url, String scheme) async {
    if (Platform.isIOS || Platform.isMacOS) {
      return false;
    }
    if (_isOpen) {
      throw PlatformException(code: 'AuthBrowser is opened.');
    }
    final isAvailable = await _channel.invokeMethod('isAvailable');
    if (Platform.isAndroid && isAvailable != null && isAvailable is bool && !isAvailable) {
      throw PlatformException(code: 'INVALID_AUTHORIZATION', message: 'can not open custom tabs.');
    }

    final available = await _channel.invokeMethod<bool?>('open', {
          'url': url,
          'redirectURL': scheme,
          'id': id,
        }) ??
        false;
    if (available) {
      _isOpen = true;
    }
    return available;
  }
}
