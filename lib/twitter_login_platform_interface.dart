import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'twitter_login_method_channel.dart';

abstract class TwitterLoginPlatform extends PlatformInterface {
  /// Constructs a TwitterLoginPlatform.
  TwitterLoginPlatform() : super(token: _token);

  static final Object _token = Object();

  static TwitterLoginPlatform _instance = MethodChannelTwitterLogin();

  /// The default instance of [TwitterLoginPlatform] to use.
  ///
  /// Defaults to [MethodChannelTwitterLogin].
  static TwitterLoginPlatform get instance => _instance;
  
  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TwitterLoginPlatform] when
  /// they register themselves.
  static set instance(TwitterLoginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
