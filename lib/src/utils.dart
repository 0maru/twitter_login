import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:twitter_login/src/signature.dart';

///
const REQUSER_TOKEN_URL = 'https://api.twitter.com/oauth/request_token';

///
const AUTHORIZE_URI = 'https://api.twitter.com/oauth/authorize';

///
const ACCESS_TOKEN_URI = 'https://api.twitter.com/oauth/access_token';

///
String authHeader(Map<String, dynamic> params) {
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
    final header = authHeader(params);
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
