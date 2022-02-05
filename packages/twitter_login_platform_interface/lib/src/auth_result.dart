import 'package:quiver/core.dart';

import 'twitter_user.dart';
import 'utils.dart';

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
