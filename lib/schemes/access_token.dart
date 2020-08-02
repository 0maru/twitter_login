import 'package:http/http.dart' as http;
import 'package:twitter_login/schemes/request_header.dart';
import 'package:twitter_login/src/signature.dart';
import 'package:twitter_login/src/utils.dart';

class AccessToken {
  /// The access token for using the Twitter APIs
  final String _authToken;

  /// The access token secret for using the Twitter APIs
  final String _authTokenSecret;

  String get authToken => _authToken;
  String get authTokenSecret => _authTokenSecret;

  AccessToken._(Map<String, dynamic> params)
      : this._authToken = params['oauth_token'],
        this._authTokenSecret = params['oauth_token_secret'];

  static Future<AccessToken> getAccessToken(
    String apiKey,
    String apiSecretKey,
    Map<String, String> queries,
  ) async {
    final authParams = RequestHeader.accessTokenHeaderParams(
      apiKey,
      queries['oauth_token'],
      queries['oauth_verifier'],
    );
    final _signature = Signature(
      url: accessTokenURI,
      method: 'POST',
      params: authParams,
      apiKey: apiKey,
      apiSecretKey: apiSecretKey,
      tokenSecretKey: '',
    );
    authParams['oauth_signature'] = _signature.signatureHmacSha1(
      _signature.getSignatureKey(),
      _signature.signatureDate(),
    );
    final String hedaer = authHeader(authParams);

    final http.BaseClient _httpClient = http.Client();
    final http.Response res = await _httpClient.post(
      accessTokenURI,
      headers: <String, String>{'Authorization': hedaer},
    );

    final Map<String, String> params = Uri.splitQueryString(res.body);
    final accessToken = AccessToken._(params);
    return accessToken;
  }
}
