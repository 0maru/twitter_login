import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:twitter_login/src/signature.dart';

/// Allows a Consumer application to obtain an OAuth Request Token to request user authorization.
const REQUEST_TOKEN_URL = 'https://api.twitter.com/oauth/request_token';

/// Allows a Consumer application to use an OAuth Request Token to request user authorization.
const AUTHORIZE_URI = 'https://api.twitter.com/oauth/authorize';

/// Allows a Consumer application to use an OAuth request_token to request user authorization.
const ACCESS_TOKEN_URI = 'https://api.twitter.com/oauth/access_token';

/// The "Request email addresses from users"
const ACCOUNT_VERIFY_URI =
    'https://api.twitter.com/1.1/account/verify_credentials.json?include_email=true';

///
String? generateAuthHeader(Map<String, dynamic> params) {
  return 'OAuth ' +
      params.keys.map((k) {
        return '$k="${Uri.encodeComponent(params[k])}"';
      }).join(', ');
}

/// send http request
Future<Map<String, dynamic>>? httpPost(
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
    final http.Client _httpClient = http.Client();
    final http.Response res = await _httpClient.post(
      Uri.parse(url),
      headers: <String, String>{'Authorization': header!},
    );
    if (res.statusCode != 200) {
      throw HttpException("Failed ${res.reasonPhrase}");
    }

    return Uri.splitQueryString(res.body);
  } on Exception {
    rethrow;
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
      method: 'GET',
      params: params,
      apiKey: apiKey,
      apiSecretKey: apiSecretKey,
      tokenSecretKey: tokenSecret,
    );
    params['oauth_signature'] = _signature.signatureHmacSha1();
    final header = generateAuthHeader(params);
    final http.Client _httpClient = http.Client();
    final http.Response res = await _httpClient.get(
      Uri.parse(url),
      headers: <String, String>{'Authorization': header!},
    );
    if (res.statusCode != 200) {
      throw HttpException("Failed ${res.reasonPhrase}");
    }

    return jsonDecode(res.body);
  } on Exception {
    rethrow;
  }
}

Map<String, String?> requestHeader({
  String? apiKey,
  String? oauthToken = '',
  String? redirectURI = '',
  String? oauthVerifier = '',
}) {
  final dtNow = DateTime.now().millisecondsSinceEpoch;
  final params = {
    'oauth_consumer_key': apiKey,
    'oauth_token': oauthToken,
    'oauth_signature_method': 'HMAC-SHA1',
    'oauth_timestamp': (dtNow / 1000).floor().toString(),
    'oauth_nonce': dtNow.toString(),
    'oauth_version': '1.0',
  };
  if (redirectURI?.isNotEmpty ?? true) {
    params.addAll({'oauth_callback': redirectURI});
  }
  if (oauthVerifier?.isNotEmpty ?? true) {
    params.addAll({'oauth_verifier': oauthVerifier});
  }
  return params;
}

String createCryptoRandomString([int length = 32]) {
  var values = List<int>.generate(length, (i) => Random.secure().nextInt(256));

  return base64Url.encode(values);
}
