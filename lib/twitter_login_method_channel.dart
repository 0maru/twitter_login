import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'twitter_login_platform_interface.dart';

/// An implementation of [TwitterLoginPlatform] that uses method channels.
class MethodChannelTwitterLogin extends TwitterLoginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('twitter_login');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
