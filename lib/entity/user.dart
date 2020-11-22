import 'package:twitter_login/schemes/request_header.dart';
import 'package:twitter_login/src/utils.dart';

class User {
  /// user email address
  final String _email;

  /// user profile image
  final String _thumbnailImage;

  /// user name
  final String _screenName;

  String get email => _email;
  String get thumbnailImage => _thumbnailImage;
  String get screenName => _screenName;

  /// constractor
  User._(Map<String, dynamic> params)
      : this._email = params['email'],
        this._thumbnailImage = params['profile_image_url_https'],
        this._screenName = params['screen_name'];

  /// get user info
  static Future<User> getUserData(
    String apiKey,
    String apiSecretKey,
    String accessToken,
    String accessTokenSecret,
  ) async {
    try {
      final authParams = RequestHeader.create(
        apiKey: apiKey,
        oauthToken: accessToken,
      );
      final params = await httpGet(
        ACCOUNT_VERIFY_URI,
        authParams,
        apiKey,
        apiSecretKey,
        accessTokenSecret,
      );
      print(params);
      return User._(params);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }
}
