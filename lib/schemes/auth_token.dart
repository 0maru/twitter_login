///The access token for using Twitter API.
class AuthToken {

  AuthToken(
    Map<String, dynamic> params,
  )   : _authToken = params['oauth_token'] as String,
        _authTokenSecret = params['oauth_token_secret'] as String;
  /// Oauth token
  final String _authToken;

  /// Oauth token secret
  final String _authTokenSecret;

  String get authToken => _authToken;
  String get authTokenSecret => _authTokenSecret;
}
