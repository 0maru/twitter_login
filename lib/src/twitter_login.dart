import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/entity/user.dart';
import 'package:twitter_login/schemes/access_token.dart';
import 'package:twitter_login/schemes/request_token.dart';
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
  /// Consumer API key
  final String apiKey;

  /// Consumer API secret key
  final String apiSecretKey;

  /// Callback URL
  final String redirectURI;

  /// request user email address
  ///
  /// To obtain an email address, an Enterprise plan is required.
  final bool requestEmail;

  static const _channel = const MethodChannel('twitter_login');
  static final _eventChannel = EventChannel('twitter_login/event');
  static final Stream<dynamic> _eventStream = _eventChannel.receiveBroadcastStream();

  /// constructor
  TwitterLogin({
    required this.apiKey,
    required this.apiSecretKey,
    required this.redirectURI,
    this.requestEmail = false,
  });

  /// Logs the user
  /// Forces the user to enter their credentials to ensure the correct users account is authorized.
  Future<AuthResult> login({bool forceLogin = false}) async {
    String? resultURI;
    RequestToken requestToken;
    try {
      requestToken = await RequestToken.getRequestToken(
        apiKey,
        apiSecretKey,
        redirectURI,
        forceLogin,
      );
    } on Exception {
      throw PlatformException(
        code: "400",
        message: "Failed to generate request token.",
        details: "Please check your APIKey or APISecret.",
      );
    }

    final uri = Uri.parse(redirectURI);
    final completer = Completer<String?>();
    late StreamSubscription subscribe;

    if (Platform.isAndroid) {
      await _channel.invokeMethod('setScheme', uri.scheme);
      subscribe = _eventStream.listen((data) async {
        if (data['type'] == 'url') {
          if (!completer.isCompleted) {
            completer.complete(data['url']?.toString());
          } else {
            throw CanceledByUserException();
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
        resultURI = await authBrowser.doAuth(requestToken.authorizeURI, uri.scheme);
      } else if (Platform.isAndroid) {
        // Login to Twitter account with chrome_custom_tabs.
        final success = await authBrowser.open(requestToken.authorizeURI, uri.scheme);
        if (!success) {
          throw PlatformException(
            code: '200',
            message: 'Could not open browser, probably caused by unavailable custom tabs.',
          );
        }
        resultURI = await completer.future;
        subscribe.cancel();
      } else {
        throw PlatformException(
          code: '100',
          message: 'Not supported by this os.',
        );
      }

      // The user closed the browser.
      if (resultURI?.isEmpty ?? true) {
        throw CanceledByUserException();
      }

      final queries = Uri.splitQueryString(Uri.parse(resultURI!).query);
      if (queries['error'] != null) {
        throw Exception('Error Response: ${queries['error']}');
      }

      // The user cancelled the login flow.
      if (queries['denied'] != null) {
        throw CanceledByUserException();
      }

      final token = await AccessToken.getAccessToken(
        apiKey,
        apiSecretKey,
        queries,
      );

      if ((token.authToken?.isEmpty ?? true) || (token.authTokenSecret?.isEmpty ?? true)) {
        return AuthResult(
          authToken: token.authToken,
          authTokenSecret: token.authTokenSecret,
          status: TwitterLoginStatus.error,
          errorMessage: 'Failed',
        );
      }

      User? user = null;
      if (requestEmail) {
        try {
          user = await User.getUserData(
            apiKey,
            apiSecretKey,
            token.authToken!,
            token.authTokenSecret!,
          );
        } on Exception {
          debugPrint(
            'User data could not be retrieved. An Enterprise plan is required to obtain user data.',
          );
        }
      }
      return AuthResult(
        authToken: token.authToken,
        authTokenSecret: token.authTokenSecret,
        status: TwitterLoginStatus.loggedIn,
        user: user,
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

  Future<AuthResult> loginV2({bool forceLogin = false}) async {
    String? resultURI;
    RequestToken requestToken;
    try {
      requestToken = await RequestToken.getRequestToken(
        apiKey,
        apiSecretKey,
        redirectURI,
        forceLogin,
      );
    } on Exception {
      throw PlatformException(
        code: "400",
        message: "Failed to generate request token.",
        details: "Please check your APIKey or APISecret.",
      );
    }

    final uri = Uri.parse(redirectURI);
    final completer = Completer<String?>();
    late StreamSubscription subscribe;

    if (Platform.isAndroid) {
      await _channel.invokeMethod('setScheme', uri.scheme);
      subscribe = _eventStream.listen((data) async {
        if (data['type'] == 'url') {
          if (!completer.isCompleted) {
            completer.complete(data['url']?.toString());
          } else {
            throw CanceledByUserException();
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
        resultURI = await authBrowser.doAuth(requestToken.authorizeURI, uri.scheme);
      } else if (Platform.isAndroid) {
        // Login to Twitter account with chrome_custom_tabs.
        final success = await authBrowser.open(requestToken.authorizeURI, uri.scheme);
        if (!success) {
          throw PlatformException(
            code: '200',
            message: 'Could not open browser, probably caused by unavailable custom tabs.',
          );
        }
        resultURI = await completer.future;
        subscribe.cancel();
      } else {
        throw PlatformException(
          code: '100',
          message: 'Not supported by this os.',
        );
      }

      // The user closed the browser.
      if (resultURI?.isEmpty ?? true) {
        throw CanceledByUserException();
      }

      final queries = Uri.splitQueryString(Uri.parse(resultURI!).query);
      if (queries['error'] != null) {
        throw Exception('Error Response: ${queries['error']}');
      }

      // The user cancelled the login flow.
      if (queries['denied'] != null) {
        throw CanceledByUserException();
      }

      final token = await AccessToken.getAccessToken(
        apiKey,
        apiSecretKey,
        queries,
      );

      if ((token.authToken?.isEmpty ?? true) || (token.authTokenSecret?.isEmpty ?? true)) {
        return AuthResult(
          authToken: token.authToken,
          authTokenSecret: token.authTokenSecret,
          status: TwitterLoginStatus.error,
          errorMessage: 'Failed',
        );
      }

      User? user = null;
      if (requestEmail) {
        try {
          user = await User.getUserDataV2(
            apiKey,
            apiSecretKey,
            token.authToken!,
            token.authTokenSecret!,
            token.userId!,
          );
        } on Exception {
          debugPrint(
            'User data could not be retrieved. An Enterprise plan is required to obtain user data.',
          );
        }
      }

      return AuthResult(
        authToken: token.authToken,
        authTokenSecret: token.authTokenSecret,
        status: TwitterLoginStatus.loggedIn,
        user: user,
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
