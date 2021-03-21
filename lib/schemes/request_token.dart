import 'package:twitter_login/src/utils.dart';

/// The Request token for Twitter API.
class RequestToken {
  /// Oauth token
  final String _token;

  /// Oauth token secret
  final String _tokenSecret;

  /// Oauth callback confirmed
  final String _callbackConfirmed;

  /// authorize url
  final String _authorizeURI;

  /// Oauth token
  String get token => _token;

  /// Oauth token secret
  String get tokenSecret => _tokenSecret;

  /// Oauth callback confirmed
  String get callbackConfirmed => _callbackConfirmed;

  /// authorize url
  String get authorizeURI => _authorizeURI;

  /// constructor
  RequestToken._(
    Map<String, dynamic> params,
    String authorizeURI,
  )   : this._token = params['oauth_token'],
        this._tokenSecret = params['oauth_token_secret'],
        this._callbackConfirmed = params['oauth_callback_confirmed'],
        this._authorizeURI = authorizeURI;

  /// Request user authorization token
  static Future<RequestToken> getRequestToken(
    String apiKey,
    String apiSecretKey,
    String redirectURI,
    bool forceLogin,
  ) async {
    final authParams = requestHeader(
      apiKey: apiKey,
      redirectURI: redirectURI,
    );
    final params = await httpPost(
      REQUEST_TOKEN_URL,
      authParams,
      apiKey,
      apiSecretKey,
    );

    var authorizeURI = '$AUTHORIZE_URI?oauth_token=${params!['oauth_token']}';
    //
    if (forceLogin) {
      authorizeURI += '&force_login=true';
    }
    final requestToken = RequestToken._(params, authorizeURI);
    if (requestToken.callbackConfirmed.toLowerCase() != 'true') {
      throw StateError('oauth_callback_confirmed mast be true');
    }

    return requestToken;
  }
}
