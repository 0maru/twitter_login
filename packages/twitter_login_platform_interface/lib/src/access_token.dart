import 'package:quiver/core.dart';

/// The access token for Twitter API.
class AccessToken {
  AccessToken({
    required this.authToken,
    required this.authTokenSecret,
  });

  /// The access token for using the Twitter APIs
  final String authToken;

  /// The access token secret for using the Twitter APIs
  final String authTokenSecret;

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      authToken: json['oauth_token'],
      authTokenSecret: json['oauth_token_secret'],
    );
  }

  @override
  int get hashCode => hashObjects(<String>[authToken, authTokenSecret]);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AccessToken) return false;
    final otherAccessToken = other;
    return otherAccessToken.authToken == authToken &&
        otherAccessToken.authTokenSecret == authTokenSecret;
  }
}
