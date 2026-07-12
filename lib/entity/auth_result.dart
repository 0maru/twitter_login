import 'dart:core';

import 'package:twitter_login/src/twitter_login.dart';

/// The result when the Twitter login flow has completed.
/// The login methods always return an instance of this class.
class AuthResult {
  /// constructor
  AuthResult({
    String? authToken,
    String? authVerifier,
    required TwitterLoginStatus status,
    String? errorMessage,
  })  : _authToken = authToken,
        _authVerifier = authVerifier,
        _status = status,
        _errorMessage = errorMessage;

  /// The access token for using the Twitter APIs
  final String? _authToken;

  /// The access token secret for using the Twitter APIs
  final String? _authVerifier;

  /// The status after a Twitter login flow has completed
  final TwitterLoginStatus? _status;

  /// The error message when the log in flow completed with an error
  final String? _errorMessage;

  String? get authToken => _authToken;
  String? get authVerifier => _authVerifier;
  TwitterLoginStatus? get status => _status;
  String? get errorMessage => _errorMessage;
}
