import 'dart:convert';

import 'package:crypto/crypto.dart';

/// OAuth 1.0a HMAC-SHA1 signature for an HTTP request
class Signature {
  /// EndpointURL
  final String url;

  /// Request method
  final String method;

  /// Request Parameter　
  final Map<String, dynamic> params;

  /// 
  final String apiKey;

  ///Oauth　token secret
  final String apiSecretKey;

  ///
  final String tokenSecretKey;

  Signature({
    this.url,
    this.method,
    this.params,
    this.apiKey,
    this.apiSecretKey,
    this.tokenSecretKey,
  });

  /// 実際に署名する
  String signatureHmacSha1(String key, String text) {
    final hmac = Hmac(sha1, key.codeUnits);
    final List<int> bytes = hmac.convert(text.codeUnits).bytes;
    return base64.encode(bytes);
  }

  /// 署名するものを作成する
  String signatureDate() {
    final uri = Uri.parse(url);
    final encodedParams = encodeParams(uri, params);
    final base = appendParams(method, uri, encodedParams);
    return base;
  }

  /// Percent encode every key and value that will be signed and Sort
  /// the list of parameters alphabetically by encoded key.
  String encodeParams(Uri uri, Map<String, dynamic> params) {
    final encodedParams = <String, String>{};
    params.forEach((k, v) {
      encodedParams[Uri.encodeComponent(k)] = Uri.encodeComponent(v as String);
    });
    uri.queryParameters.forEach((k, v) {
      encodedParams[Uri.encodeComponent(k)] = Uri.encodeComponent(v);
    });
    final sortedEncodedKeys = encodedParams.keys.toList()..sort();
    return sortedEncodedKeys.map((k) {
      return '$k=${params[k]}';
    }).join('&');
  }

  /// Create a Http Request 
  String appendParams(
    String method,
    Uri uri,
    String baseParams,
  ) {
    final base = StringBuffer();
    base.write(method.toUpperCase());
    base.write('&');
    base.write(Uri.encodeComponent(uri.origin + uri.path));
    base.write('&');
    base.write(Uri.encodeComponent(baseParams));
    return base.toString();
  }

  /// create a signing key which will be used to generate the signature
  String getSignatureKey() {
    final consumerSecret = Uri.encodeComponent(apiSecretKey);
    final tokenSecret = tokenSecretKey != null ? Uri.encodeComponent(tokenSecretKey) : '';
    return '$consumerSecret&$tokenSecret';
  }
}
