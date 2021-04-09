import 'package:twitter_login/src/utils.dart';

/// https://developer.twitter.com/en/docs/twitter-api/data-dictionary/object-model/user
class User {
  /// The unique identifier of this user.
  ///
  /// Use this to programmatically retrieve information about a specific Twitter user.
  final int _id;

  /// user email address
  final String _email;

  /// user profile image
  final String _thumbnailImage;

  /// user name
  final String _name;

  /// user name
  final String _screenName;

  /// The unique identifier of this user.
  ///
  /// Use this to programmatically retrieve information about a specific Twitter user.
  int get id => _id;

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

  /// constractor
  User._(Map<String, dynamic> params)
      : this._id = params['id'] ?? '',
        this._email = params['email'] ?? '',
        this._thumbnailImage = params['profile_image_url_https'],
        this._name = params['name'],
        this._screenName = params['screen_name'];

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
      return User._(params);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }
}
