import 'package:quiver/core.dart';

/// The Request token for Twitter API.
class RequestToken {
  RequestToken({
    required this.token,
    required this.tokenSecret,
    required this.callbackConfirmed,
    required this.authorizeURI,
  });

  /// Oauth token
  final String token;

  /// Oauth token secret
  final String tokenSecret;

  /// Oauth callback confirmed
  final String callbackConfirmed;

  /// authorize url
  final String authorizeURI;

  @override
  int get hashCode => hashObjects(<String>[token, tokenSecret, callbackConfirmed, authorizeURI]);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! RequestToken) return false;
    final otherRequestToken = other;
    return otherRequestToken.token == token &&
        otherRequestToken.tokenSecret == tokenSecret &&
        otherRequestToken.callbackConfirmed == callbackConfirmed &&
        otherRequestToken.authorizeURI == authorizeURI;
  }
}
