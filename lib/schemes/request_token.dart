import 'package:twitter_login/schemes/request_header.dart';
import 'package:twitter_login/src/utils.dart';

/// The Request token for Twitter API.
class RequestToken {
  /// Oauth token
  final String _token;

  /// Oauth token secret
  final String _tokenSecret;

  /// Oauth callback confirmed
  final String _callbackConfirmed;

  String get token => _token;
  String get tokenSecret => _tokenSecret;
  String get callbackConfirmed => _callbackConfirmed;
  String get authorizeURI => '$AUTHORIZE_URI?oauth_token=$_token';

  /// constructor
  RequestToken._(
    Map<String, dynamic> params,
    String authorizeURI,
  )   : this._token = params['oauth_token'],
        this._tokenSecret = params['oauth_token_secret'],
        this._callbackConfirmed = params['oauth_callback_confirmed'];

  /// Request user authorization token
  static Future<RequestToken> getRequestToken(
    String apiKey,
    String apiSecretKey,
    String redirectURI,
    bool forceLogin,
  ) async {
    final authParams = RequestHeader.authorizeHeaderParams(
      apiKey,
      redirectURI,
    );
    final params = await send(
      REQUSER_TOKEN_URL,
      authParams,
      apiKey,
      apiSecretKey,
    );

    var authorizeURI = '$ACCESS_TOKEN_URI?oauth_token=${params['oauth_token']}';
    if (forceLogin) {
      authorizeURI += '&force_login';
    }
    final requestToken = RequestToken._(params, authorizeURI);
    if (requestToken.callbackConfirmed.toLowerCase() != 'true') {
      throw StateError('oauth_callback_confirmed mast be true');
    }

    return requestToken;
  }
}
