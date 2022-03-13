import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'access_token.dart';
import 'auth_result.dart';
import 'twitter_user.dart';

/// The interface that implementations of twitter_login must implement.
abstract class TwitterLoginPlatform extends PlatformInterface {
  TwitterLoginPlatform({
    required this.apiKey,
    required this.apiSecretKey,
    required this.redirectURI,
  }) : super(token: _token);

  static final Object _token = Object();

  /// Consumer API key
  final String apiKey;

  /// Consumer API secret key
  final String apiSecretKey;

  /// Callback URL
  final String redirectURI;

  // ignore: public_member_api_doc
  Future<AuthResult> login() {
    throw UnimplementedError('login() has not been implemented.');
  }

  // ignore: public_member_api_doc
  Future<AccessToken> getAccessToken() {
    throw UnimplementedError('getAccessToken() has not been implemented.');
  }

  // ignore: public_member_api_doc
  Future<TwitterUser> getUserData() {
    throw UnimplementedError('getUserData() has not been implemented.');
  }
}
