import 'dart:core';

import 'package:twitter_login/entity/user.dart';
import 'package:twitter_login/schemes/access_token.dart';
import 'package:twitter_login/src/twitter_login.dart';

/// The result when the Twitter login flow has completed.
/// The login methods always return an instance of this class.
class AuthResult {
  /// The access token for using the Twitter APIs
  final AccessToken? _accessToken;

  /// The access token for using the Twitter APIs
  final String? _authToken;

  //// The access token secret for using the Twitter APIs
  final String? _authTokenSecret;

  /// The status after a Twitter login flow has completed
  final TwitterLoginStatus? _status;

  /// The error message when the log in flow completed with an error
  final String? _errorMessage;

  /// Twitter Account user Info.
  final User? _user;

  @deprecated
  AccessToken? get accessToken => _accessToken;
  String? get authToken => _authToken;
  String? get authTokenSecret => _authTokenSecret;
  TwitterLoginStatus? get status => _status;
  String? get errorMessage => _errorMessage;
  User? get user => _user;

  /// constractor
  AuthResult({
    AccessToken? accessToken,
    String? authToken,
    String? authTokenSecret,
    TwitterLoginStatus? status,
    String? errorMessage,
    User? user,
  })  : this._accessToken = accessToken,
        this._authToken = authToken,
        this._authTokenSecret = authTokenSecret,
        this._status = status,
        this._errorMessage = errorMessage,
        this._user = user;
}
