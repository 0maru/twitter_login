import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:twitter_login/schemes/access_token.dart';
import 'package:twitter_login/schemes/auth_result.dart';
import 'package:twitter_login/schemes/request_token.dart';
import 'package:twitter_login/src/chrome_custom_tab.dart';

/// The status after a Twitter login flow has completed.
enum TwitterLoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow.
  cancelledByUser,

  /// The Twitter login completed with an error
  error,
}

class TwitterLogin {
  // Consumer API key
  final String apiKey;

  // Consumer API secret key
  final String apiSecretKey;

  // Callback URL
  final String redirectURI;

  static const _channel = const MethodChannel('twitter_login');
  static final _eventChannel = EventChannel('twitter_login/event');
  static final Stream<dynamic> _eventStream = _eventChannel.receiveBroadcastStream();

  TwitterLogin({
    this.apiKey,
    this.apiSecretKey,
    this.redirectURI,
  });

  // TODO: Error 時の処理
  Future<AuthResult> login() async {
    // TODO: requestTokenが取れなかったらエラー
    try {
      final requestToken = await getRequestToken();

      String resultURI = '';
      if (Platform.isIOS) {
        // PlatformView でログイン処理
        resultURI = await _channel.invokeMethod('authentication', {
          'url': requestToken.authorizeURI,
          'redirectURL': redirectURI,
        });
      } else if (Platform.isAndroid) {
        // in_app_browser でログイン処理
        final uri = Uri.parse(redirectURI);
        await _channel.invokeMethod('setScheme', uri.scheme);
        final completer = Completer<String>();
        final subscribe = _eventStream.listen((data) async {
          if (data['type'] == 'url') {
            completer.complete(data['url']?.toString());
          }
        });
        final browser = ChromeCustomTab(onClose: () {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        });
        await browser.open(url: requestToken.authorizeURI);
        resultURI = await completer.future;
        subscribe.cancel();
      } else {
        throw Exception();
      }
      // query からToken を取得する
      final params = Uri.splitQueryString(Uri.parse(resultURI).query);
      if (params['error'] != null) {
        throw Exception('Error Response: ${params['error']}');
      }

      // ユーザーがキャンセルした
      if (params['denied'] != null) {
        return AuthResult(
          accessToken: null,
          status: TwitterLoginStatus.error,
          errorMessage: 'The user cancelled the login flow',
        );
      }

      final accessToken = await AccessToken.getAccessToken(
        apiKey,
        apiSecretKey,
        params['oauth_token'],
        params['oauth_verifier'],
      );
      return AuthResult(
        accessToken: accessToken,
        status: TwitterLoginStatus.loggedIn,
        errorMessage: '',
      );
    } catch (error) {
      return AuthResult(
        accessToken: null,
        status: TwitterLoginStatus.error,
        errorMessage: error.message.toString(),
      );
    }
  }

  Future<RequestToken> getRequestToken() async => await RequestToken.getRequestToken(
        apiKey,
        apiSecretKey,
        redirectURI,
      );
}
