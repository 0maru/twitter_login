import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/entity/user.dart';
import 'package:twitter_login/schemes/access_token.dart';
import 'package:twitter_login/schemes/request_token.dart';
import 'package:twitter_login/src/chrome_custom_tab.dart';
import 'package:twitter_login/src/exception.dart';

/// The status after a Twitter login flow has completed.
enum TwitterLoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow.
  cancelledByUser,

  /// The Twitter login completed with an error
  error,
}

///
class TwitterLogin {
  /// Consumer API key
  final String apiKey;

  /// Consumer API secret key
  final String apiSecretKey;

  /// Callback URL
  final String redirectURI;

  static const _channel = const MethodChannel('twitter_login');
  static final _eventChannel = EventChannel('twitter_login/event');
  static final Stream<dynamic> _eventStream = _eventChannel.receiveBroadcastStream();

  /// constructor
  TwitterLogin({
    required this.apiKey,
    required this.apiSecretKey,
    required this.redirectURI,
  });

  /// Logs the user
  /// Forces the user to enter their credentials to ensure the correct users account is authorized.
  Future<AuthResult> login({bool forceLogin = false}) async {
    try {
      final requestToken = await RequestToken.getRequestToken(
        apiKey,
        apiSecretKey,
        redirectURI,
        forceLogin,
      );
      String? resultURI = '';
      final uri = Uri.parse(redirectURI);
      if (Platform.isIOS) {
        resultURI = await _channel.invokeMethod('authentication', {
          'url': requestToken.authorizeURI,
          'redirectURL': uri.scheme,
        });
      } else if (Platform.isAndroid) {
        await _channel.invokeMethod('setScheme', uri.scheme);
        final completer = Completer<String>();
        final subscribe = _eventStream.listen((data) async {
          if (data['type'] == 'url') {
            completer.complete(data['url']?.toString());
          }
        });
        final browser = ChromeCustomTab(
          onClose: () {
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          },
        );
        await browser.open(url: Uri.parse(requestToken.authorizeURI));
        resultURI = await completer.future;
        subscribe.cancel();
      } else {
        throw UnsupportedError('Not supported by this os.');
      }
      // The user closed the browser
      if (resultURI!.isEmpty) {
        throw CanceldByUserException();
      }
      final queries = Uri.splitQueryString(Uri.parse(resultURI).query);
      if (queries['error'] != null) {
        throw Exception('Error Response: ${queries['error']}');
      }

      // The user cancelled the login flow.
      if (queries['denied'] != null) {
        throw CanceldByUserException();
      }

      final accessToken = await AccessToken.getAccessToken(
        apiKey,
        apiSecretKey,
        queries,
      );

      final userData = await User.getUserData(
        apiKey,
        apiSecretKey,
        accessToken.authToken,
        accessToken.authTokenSecret,
      );

      return AuthResult(
        accessToken: accessToken,
        authToken: accessToken.authToken,
        authTokenSecret: accessToken.authTokenSecret,
        status: TwitterLoginStatus.loggedIn,
        errorMessage: '',
        user: userData,
      );
    } on CanceldByUserException {
      return AuthResult(
        accessToken: null,
        authToken: null,
        authTokenSecret: null,
        status: TwitterLoginStatus.cancelledByUser,
        errorMessage: 'The user cancelled the login flow',
        user: null,
      );
    } catch (error) {
      return AuthResult(
        accessToken: null,
        authToken: null,
        authTokenSecret: null,
        status: TwitterLoginStatus.error,
        errorMessage: error.toString(),
        user: null,
      );
    }
  }
}
