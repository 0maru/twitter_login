import 'package:twitter_login/schemes/access_token.dart';
import 'package:twitter_login/src/twitter_login.dart';

class AuthResult {
  // The access token for using the Twitter APIs
  final AccessToken _accessToken;

  // The status after a Twitter login flow has completed
  final TwitterLoginStatus _status;

  // The error message when the log in flow completed with an error
  final String _errorMessage;

  AuthResult({
    AccessToken accessToken,
    TwitterLoginStatus status,
    String errorMessage,
  })  : this._accessToken = accessToken,
        this._status = status,
        this._errorMessage = errorMessage;

  AccessToken get accessToken => _accessToken;
  TwitterLoginStatus get status => _status;
  String get errorMessage => _errorMessage;
}
