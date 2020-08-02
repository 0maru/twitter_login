import 'package:twitter_login/schemes/request_header.dart';
import 'package:twitter_login/src/http_client.dart';
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
  String get authorizeURI => '$authorizeURI?oauth_token=$_token';

  /// constract
  RequestToken._(Map<String, dynamic> params)
      : this._token = params['oauth_token'],
        this._tokenSecret = params['oauth_token_secret'],
        this._callbackConfirmed = params['oauth_callback_confirmed'];

  /// Request user authorization token
  static Future<RequestToken> getRequestToken(
    String apiKey,
    String apiSecretKey,
    String redirectURI,
  ) async {
    final authParams = RequestHeader.authorizeHeaderParams(
      apiKey,
      redirectURI,
    );
    final params = await HttpClient.send(
      requestTokenURI,
      authParams,
      apiKey,
      apiSecretKey,
    );
    final requestToken = RequestToken._(params);
    if (requestToken.callbackConfirmed.toLowerCase() != 'true') {
      throw StateError('oauth_callback_confirmed mast be true');
    }

    return requestToken;
  }
}
