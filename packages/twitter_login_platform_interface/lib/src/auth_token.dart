import 'package:quiver/core.dart';

///The access token for using Twitter API.
class AuthToken {
  AuthToken({
    required this.authToken,
    required this.authTokenSecret,
  });

  /// Oauth token
  final String authToken;

  /// Oauth token secret
  final String authTokenSecret;

  factory AuthToken.fromJson(Map<String, dynamic> params) {
    return AuthToken(
      authToken: params['oauth_token'] ?? '',
      authTokenSecret: params['oauth_token_secret'] ?? '',
    );
  }

  @override
  int get hashCode => hashObjects(<String>[authToken, authTokenSecret]);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AuthToken) return false;
    final otherAuthToken = other;
    return otherAuthToken.authToken == authToken &&
        otherAuthToken.authTokenSecret == authTokenSecret;
  }
}
