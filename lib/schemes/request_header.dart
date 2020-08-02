import 'dart:convert';
import 'package:flutter/foundation.dart';

const SIGNATURE_METHOD = 'HMAC-SHA1';

class RequestHeader {
  /// Unique token your application should generate for each unique request.
  final String _nonce;

  /// The number of seconds since the Unix epoch
  final String _timestamp;

  /// Application identifies
  final String _consumerKey;

  /// Twitter API version
  final String _version;

  /// Access token with your application
  final String _token;

  /// oauth verifier code
  final String _verifier;

  String get nonce => _nonce;
  String get timestamp => _timestamp;
  String get consumerKey => _consumerKey;
  String get version => _version;
  String get token => _token;
  String get verifier => _verifier;

  RequestHeader._({
    @required String nonce,
    @required String timestamp,
    @required String consumerKey,
    @required String version,
    @required String token,
    @required String verifier,
  })  : this._nonce = nonce,
        this._timestamp = timestamp,
        this._consumerKey = consumerKey,
        this._version = version,
        this._token = token,
        this._verifier = verifier;

  /// Json serialize
  String serialize() {
    return JsonEncoder().convert({
      'oauth_consumer_key': _consumerKey,
      'oauth_signature_method': SIGNATURE_METHOD,
      'oauth_signature': '',
      'oauth_timestamp': '',
      'oauth_nonce': _nonce,
      'oauth_version': _version,
      'oauth_callback': ''
    });
  }

  /// create requser header for /authorize
  static Map<String, dynamic> authorizeHeaderParams(
    String apiKey,
    String redirectURI,
  ) {
    final dtNow = DateTime.now().millisecondsSinceEpoch;
    return {
      'oauth_consumer_key': apiKey,
      'oauth_token': '',
      'oauth_signature_method': SIGNATURE_METHOD,
      'oauth_timestamp': (dtNow / 1000).floor().toString(),
      'oauth_nonce': dtNow.toString(),
      'oauth_version': '1.0',
      'oauth_callback': redirectURI,
    };
  }

  /// create requser header for /access_token
  static Map<String, dynamic> accessTokenHeaderParams(
    String apiKey,
    String oauthToken,
    String oauthVerifier,
  ) {
    final dtNow = DateTime.now().millisecondsSinceEpoch;
    return {
      'oauth_consumer_key': apiKey,
      'oauth_token': oauthToken,
      'oauth_signature_method': SIGNATURE_METHOD,
      'oauth_timestamp': (dtNow / 1000).floor().toString(),
      'oauth_nonce': dtNow.toString(),
      'oauth_version': '1.0',
      'oauth_verifier': oauthVerifier,
    };
  }
}
