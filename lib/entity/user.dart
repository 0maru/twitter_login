import 'package:twitter_login/src/utils.dart';

class User {
  /// user email address
  ///
  /// If your Twitter account does not have an email address,
  /// or if the API is not configured to retrieve email addresses,
  /// you may not be able to retrieve email addresses.
  final String _email;

  /// user profile image
  final String _thumbnailImage;

  /// user name
  final String _name;

  /// user name
  final String _screenName;

  /// user email address
  ///
  /// If your Twitter account does not have an email address,
  /// or if the API is not configured to retrieve email addresses,
  /// you may not be able to retrieve email addresses.
  String get email => _email;

  /// thumbnailImage
  String get thumbnailImage => _thumbnailImage;

  /// Twitter account name
  String get name => _name;

  /// Twitter account id
  String get screenName => _screenName;

  /// constructor
  User(Map<String, dynamic> params)
      : this._email = params['email'] ?? '',
        this._thumbnailImage = params['profile_image_url_https'] ?? '',
        this._name = params['name'] ?? '',
        this._screenName = params['screen_name'] ?? '';

  /// get user info
  static Future<User> getUserData(
    String apiKey,
    String apiSecretKey,
    String accessToken,
    String accessTokenSecret,
  ) async {
    try {
      final authParams = requestHeader(
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
      return User(params);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }
}
