import 'package:twitter_login/src/utils.dart';

/// The access token for Twitter API.
class AccessToken {
  AccessToken(Map<String, dynamic> params)
      : authToken = params.get<String?>('oauth_token'),
        authTokenSecret = params.get<String?>('oauth_token_secret'),
        userId = params.get<String?>('user_id'),
        screenName = params.get<String?>('screen_name');
  final String? authToken;
  final String? authTokenSecret;
  final String? userId;
  final String? screenName;

  static Future<AccessToken> getAccessToken(
    String apiKey,
    String apiSecretKey,
    Map<String, String> queries,
  ) async {
    final authParams = requestHeader(
      apiKey: apiKey,
      oauthToken: queries['oauth_token'],
      oauthVerifier: queries['oauth_verifier'],
    );
    final params = await httpPost(
      ACCESS_TOKEN_URI,
      authParams,
      apiKey,
      apiSecretKey,
    );
    if (params == null) {
      throw Exception();
    }
    return AccessToken(params);
  }
}
