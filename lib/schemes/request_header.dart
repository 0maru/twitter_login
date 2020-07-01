import 'dart:convert';

import 'package:flutter/foundation.dart';

class RequestHeader {
  final String _nonce;
  final String _signatureMethod;
  final String _timestamp;
  final String _consumerKey;
  final String _version;
  final String _token;
  final String _verifier;

  String get nonce => _nonce;
  String get signatureMethod => _signatureMethod;
  String get timestamp => _timestamp;
  String get consumerKey => _consumerKey;
  String get version => _version;
  String get token => _token;
  String get verifier => _verifier;

  RequestHeader._({
    @required String nonce,
    @required String signatureMethod,
    @required String timestamp,
    @required String consumerKey,
    @required String version,
    @required String token,
    @required String verifier,
  })  : this._nonce = nonce,
        this._signatureMethod = signatureMethod,
        this._timestamp = timestamp,
        this._consumerKey = consumerKey,
        this._version = version,
        this._token = token,
        this._verifier = verifier;

  String serialize() {
    return JsonEncoder().convert({
      'oauth_consumer_key': _consumerKey,
      'oauth_signature_method': _signatureMethod,
      'oauth_signature': '',
      'oauth_timestamp': '',
      'oauth_nonce': _nonce,
      'oauth_version': _version,
      'oauth_callback': ''
    });
  }

  String authorizeHeader(
    String apiKey,
    String signatureDate,
  ) {
    final Map<String, String> params = <String, String>{};
    final int millSeconds = DateTime.now().millisecondsSinceEpoch;
    params['oauth_nonce'] = millSeconds.toString();
    params['oauth_signature_method'] = 'HMAC-SHA1';
    params['oauth_timestamp'] = (millSeconds / 1000).floor().toString();
    params['oauth_consumer_key'] = apiKey;
    params['oauth_version'] = '1.0';

    if (!params.containsKey('oauth_signature')) {
      params['oauth_signature'] = signatureDate;
    }
    return 'OAuth ' +
        params.keys
            .map((k) => '$k="${Uri.encodeComponent(params[k])}"')
            .join(', ');
  }

  static Map<String, dynamic> authorizeHeaderParams(
    String apiKey,
    String redirectURI,
  ) {
    final int dtNow = DateTime.now().millisecondsSinceEpoch;
    return {
      'oauth_consumer_key': apiKey,
      'oauth_token': '',
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': (dtNow / 1000).floor().toString(),
      'oauth_nonce': dtNow.toString(),
      'oauth_version': '1.0',
      'oauth_callback': redirectURI,
    };
  }

  static Map<String, dynamic> accessTokenHeaderParams(
    String apiKey,
    String oauthToken,
    String oauthVerifier,
  ) {
    final int dtNow = DateTime.now().millisecondsSinceEpoch;
    return {
      'oauth_consumer_key': apiKey,
      'oauth_token': oauthToken,
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': (dtNow / 1000).floor().toString(),
      'oauth_nonce': dtNow.toString(),
      'oauth_version': '1.0',
      'oauth_verifier': oauthVerifier,
    };
  }
}
