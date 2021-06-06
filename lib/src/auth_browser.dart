import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const String methodName = 'twitter_login/auth_browser';

class AuthBrowser {
  late final String id;
  static const _channel = const MethodChannel(methodName);
  late MethodChannel _methodCallHandlerChannel;
  bool _isOpen = false;
  VoidCallback onClose;

  AuthBrowser({required this.onClose}) {
    id = IdGenerator.generate();
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

class IdGenerator {
  static int _count = 0;

  /// Math.Random()-based RNG. All platforms, fast, not cryptographically strong. Optional Seed passable.
  static Uint8List mathRNG({int seed = -1}) {
    var b = Uint8List(16);

    var rand = (seed == -1) ? Random() : Random(seed);

    for (var i = 0; i < 16; i++) {
      b[i] = rand.nextInt(256);
    }

    (seed == -1) ? b.shuffle() : b.shuffle(Random(seed));

    return b;
  }

  /// Crypto-Strong RNG. All platforms, unknown speed, cryptographically strong (theoretically)
  static Uint8List cryptoRNG() {
    var b = Uint8List(16);
    var rand = Random.secure();
    for (var i = 0; i < 16; i++) {
      b[i] = rand.nextInt(256);
    }
    return b;
  }

  static String generate() {
    _count++;
    return _count.toString() + cryptoRNG().map((e) => e.toString()).join('');
  }
}
