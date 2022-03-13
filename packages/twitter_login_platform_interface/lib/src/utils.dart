import 'dart:math';

/// The status after a Twitter login flow has completed.
enum TwitterLoginStatus {
  /// The login was successful and the user is now logged in.
  loggedIn,

  /// The user cancelled the login flow.
  cancelledByUser,

  /// The Twitter login completed with an error
  error,
}

/// Twitter API Endpoint host
const host = 'api.twitter.com';

/// Allows a Consumer application to obtain an OAuth Request Token to request user authorization.
const requestTokenPath = 'oauth/request_token';

/// Allows a Consumer application to use an OAuth Request Token to request user authorization.
const authorizePath = 'oauth/authorize';

/// Allows a Consumer application to use an OAuth request_token to request user authorization.
const accessTokenPath = 'oauth/access_token';

/// Generate a cryptographically secure random nonce
String generateNonce([int length = 32]) {
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
  final random = Random.secure();

  return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
}
