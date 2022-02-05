import 'package:quiver/core.dart';
import 'package:twitter_login_platform_interface/src/utils.dart';

/// The result when the Twitter login flow has completed.
/// The login methods always return an instance of this class.
class AuthResult {
  /// constructor
  AuthResult({
    this.authToken,
    this.authTokenSecret,
    required this.status,
    this.errorMessage,
    this.user,
  });

  /// The access token for using the Twitter APIs
  final String? authToken;

  //// The access token secret for using the Twitter APIs
  final String? authTokenSecret;

  /// The status after a Twitter login flow has completed
  final TwitterLoginStatus status;

  /// The error message when the log in flow completed with an error
  final String? errorMessage;

  /// Twitter Account user Info.
  final TwitterUser? user;

  @override
  int get hashCode => hashObjects(<String?>[
        authToken,
        authTokenSecret,
        status.name,
        errorMessage,
        user.toString(),
      ]);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! AuthResult) return false;
    final otherResultDate = other;
    return otherResultDate.authToken == authToken &&
        otherResultDate.authTokenSecret == authTokenSecret &&
        otherResultDate.status == status &&
        otherResultDate.errorMessage == errorMessage &&
        otherResultDate.user == user;
  }
}

/// docs: https://developer.twitter.com/en/docs/twitter-api/data-dictionary/object-model/user
class TwitterUser {
  /// constructor
  TwitterUser({
    required this.id,
    this.email,
    required this.thumbnailImage,
    required this.name,
    required this.screenName,
  });

  /// The unique identifier of this user.
  ///
  /// Use this to programmatically retrieve information about a specific Twitter user.
  final int id;

  /// user email address
  final String? email;

  /// user profile image
  final String thumbnailImage;

  /// user name
  final String name;

  /// user name
  final String screenName;

  @override
  int get hashCode =>
      hashObjects(<String?>[id.toString(), email, thumbnailImage, name, screenName]);

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! TwitterUser) return false;
    final otherTwitterUser = other;
    return otherTwitterUser.id == id &&
        otherTwitterUser.email == email &&
        otherTwitterUser.thumbnailImage == thumbnailImage &&
        otherTwitterUser.name == name &&
        otherTwitterUser.screenName == screenName;
  }
}

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
