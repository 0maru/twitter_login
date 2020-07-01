import 'dart:convert';

import 'package:crypto/crypto.dart';

class Signature {
  final String url;
  final String method;
  final Map<String, dynamic> params;
  final String apiKey;
  final String apiSecretKey;
  final String tokenSecretKey;

  Signature({
    this.url,
    this.method,
    this.params,
    this.apiKey,
    this.apiSecretKey,
    this.tokenSecretKey,
  });

  StringBuffer signatureDate() {
    final Uri uri = Uri.parse(url);
    final Map<String, String> encodedParams = encodeParams(uri, params);
    final String baseParams = sortParamsToEncodedKey(encodedParams);
    final StringBuffer base = appendParams(method, uri, baseParams);
    return base;
  }

  Map<String, String> encodeParams(Uri uri, Map<String, dynamic> params) {
    final Map<String, String> encodedParams = <String, String>{};
    params.forEach((String k, dynamic v) {
      encodedParams[Uri.encodeComponent(k)] = Uri.encodeComponent(v as String);
    });
    uri.queryParameters.forEach((String k, dynamic v) {
      encodedParams[Uri.encodeComponent(k)] = Uri.encodeComponent(v as String);
    });
    return encodedParams;
  }

  String sortParamsToEncodedKey(Map<String, String> params) {
    final List<String> sortedEncodedKeys = params.keys.toList()..sort();
    final String baseParams = sortedEncodedKeys.map((String k) {
      return '$k=${params[k]}';
    }).join('&');
    return baseParams;
  }

  StringBuffer appendParams(String method, Uri uri, String baseParams) {
    final StringBuffer base = StringBuffer();
    base.write(method.toUpperCase());
    base.write('&');
    base.write(Uri.encodeComponent(uri.origin + uri.path));
    base.write('&');
    base.write(Uri.encodeComponent(baseParams));
    return base;
  }

  String createSignatureKey() {
    final String consumerSecret = Uri.encodeComponent(apiSecretKey);
    final String tokenSecret =
        tokenSecretKey != null ? Uri.encodeComponent(tokenSecretKey) : '';
    return '$consumerSecret&$tokenSecret';
  }

  String signatureHmacSha1(String key, String text) {
    final Hmac hmac = Hmac(sha1, key.codeUnits);
    final List<int> bytes = hmac.convert(text.codeUnits).bytes;
    return base64.encode(bytes);
  }
}
