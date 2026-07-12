import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:twitter_login/entity/auth_result.dart';

import 'package:twitter_login/src/auth_browser.dart';
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
  /// constructor
  TwitterLogin({
    required this.redirectURI,
  });

  /// Callback URL
  final String redirectURI;

  static const _channel = MethodChannel('twitter_login');
  static const _eventChannel = EventChannel('twitter_login/event');
  static final Stream<dynamic> _eventStream = _eventChannel.receiveBroadcastStream();

  ///使用更安全的登录交互方式
  Future<AuthResult> login({required String oauthToken, required String oauthUrl}) async {
    String? resultURI;

    final uri = Uri.parse(redirectURI);
    final completer = Completer<String?>();
    late StreamSubscription<void> subscribe;

    if (Platform.isAndroid) {
      await _channel.invokeMethod('setScheme', uri.scheme);
      subscribe = _eventStream.listen((data) async {
        if (data['type'] == 'url') {
          if (!completer.isCompleted) {
            completer.complete(data['url']?.toString());
          } else {
            throw const CanceledByUserException();
          }
        }
      });
    }

    final authBrowser = AuthBrowser(
      onClose: () {
        if (!completer.isCompleted) {
          completer.complete(null);
        }
      },
    );

    try {
      if (Platform.isIOS || Platform.isMacOS) {
        /// Login to Twitter account with SFAuthenticationSession or ASWebAuthenticationSession.
        resultURI = await authBrowser.doAuth(oauthUrl, uri.scheme);
      } else if (Platform.isAndroid) {
        // Login to Twitter account with chrome_custom_tabs.
        final success = await authBrowser.open(oauthUrl, uri.scheme);
        if (!success) {
          throw PlatformException(
            code: '200',
            message: 'Could not open browser, probably caused by unavailable custom tabs.',
          );
        }
        resultURI = await completer.future;
        await subscribe.cancel();
      } else {
        throw PlatformException(
          code: '100',
          message: 'Not supported by this os.',
        );
      }

      // The user closed the browser.
      if (resultURI?.isEmpty ?? true) {
        throw const CanceledByUserException();
      }

      final queries = Uri.splitQueryString(Uri.parse(resultURI!).query);
      if (queries['error'] != null) {
        throw Exception('Error Response: ${queries['error']}');
      }

      // The user cancelled the login flow.
      if (queries['denied'] != null) {
        throw const CanceledByUserException();
      }

      return AuthResult(
        authToken: queries['oauth_token'],
        authVerifier: queries['oauth_verifier'],
        status: TwitterLoginStatus.loggedIn,
      );
    } on CanceledByUserException {
      return AuthResult(
        status: TwitterLoginStatus.cancelledByUser,
        errorMessage: 'The user cancelled the login flow.',
      );
    } catch (error) {
      return AuthResult(
        status: TwitterLoginStatus.error,
        errorMessage: error.toString(),
      );
    }
  }
}
