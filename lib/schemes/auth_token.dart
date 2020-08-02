///The access token for using Twitter API.
class AuthToken {
  /// Oauth token
  final String _authToken;

  /// Oauth token secret
  final String _authTokenSecret;

  String get authToken => _authToken;
  String get authTokenSecret => _authTokenSecret;

  AuthToken._(
    Map<String, dynamic> params,
  )   : this._authToken = params['oauth_token'],
        this._authTokenSecret = params['oauth_token_secret'];
}
