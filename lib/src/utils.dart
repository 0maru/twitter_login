import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:twitter_login/src/signature.dart';

/// Allows a Consumer application to obtain an OAuth Request Token to request user authorization.
const REQUSER_TOKEN_URL = 'https://api.twitter.com/oauth/request_token';

/// Allows a Consumer application to use an OAuth Request Token to request user authorization.
const AUTHORIZE_URI = 'https://api.twitter.com/oauth/authorize';

/// Allows a Consumer application to use an OAuth request_token to request user authorization.
const ACCESS_TOKEN_URI = 'https://api.twitter.com/oauth/access_token';

/// The "Request email addresses from users"
const ACCOUNT_VERIFY_URI =
    'https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true';

///
String generateAuthHeader(Map<String, dynamic> params) {
  return 'OAuth ' +
      params.keys.map((k) {
        return '$k="${Uri.encodeComponent(params[k])}"';
      }).join(', ');
}

/// send http request
Future<Map<String, dynamic>> send(
  String url,
  Map<String, dynamic> params,
  String apiKey,
  String apiSecretKey,
) async {
  try {
    final _signature = Signature(
      url: url,
      params: params,
      apiKey: apiKey,
      apiSecretKey: apiSecretKey,
      tokenSecretKey: '',
    );
    params['oauth_signature'] = _signature.signatureHmacSha1();
    final header = generateAuthHeader(params);
    final http.BaseClient _httpClient = http.Client();
    final http.Response res = await _httpClient.post(
      url,
      headers: <String, String>{'Authorization': header},
    );
    if (res.statusCode != 200) {
      throw HttpException("Failed ${res.reasonPhrase}");
    }

    return Uri.splitQueryString(res.body);
  } on Exception catch (error) {
    throw Exception(error);
  }
}

Future<Map<String, dynamic>> httpGet(
  String url,
  Map<String, dynamic> params,
  String apiKey,
  String apiSecretKey,
  String tokenSecret,
) async {
  try {
    final _signature = Signature(
      url: url,
      params: params,
      apiKey: apiKey,
      apiSecretKey: apiSecretKey,
      tokenSecretKey: tokenSecret,
    );
    params['oauth_signature'] = _signature.signatureHmacSha1();
    final header = generateAuthHeader(params);
    final http.BaseClient _httpClient = http.Client();
    final http.Response res = await _httpClient.get(
      url,
      headers: <String, String>{'Authorization': header},
    );
    if (res.statusCode != 200) {
      throw HttpException("Failed ${res.reasonPhrase}");
    }

    return Uri.splitQueryString(res.body);
  } on Exception catch (error) {
    throw Exception(error);
  }
}
