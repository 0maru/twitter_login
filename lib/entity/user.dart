import 'package:twitter_login/src/oauth_2.dart';
import 'package:twitter_login/src/utils.dart';

/// https://developer.twitter.com/en/docs/twitter-api/data-dictionary/object-model/user
class User {
  /// constructor
  User(Map<String, dynamic> params)
      : _id = params.get<int>('id')!,
        // ignore: deprecated_member_use_from_same_package
        _email = params.get<String?>('email') ?? '',
        _thumbnailImage = params.get<String?>('profile_image_url_https') ?? '',
        _name = params.get<String?>('name') ?? '',
        _screenName = params.get<String?>('screen_name') ?? '';

  /// The unique identifier of this user.
  ///
  /// Use this to programmatically retrieve information about a specific Twitter user.
  final int _id;

  /// user email address
  @Deprecated('')
  final String _email;

  /// user profile image
  final String _thumbnailImage;

  /// The Twitter screen name, handle, or alias that this user identifies themselves with.
  /// Usernames are unique but subject to change.
  /// Typically a maximum of 15 characters long, but some historical accounts may exist with longer names.
  ///
  /// user name
  final String _name;

  /// The name of the user, as they’ve defined it on their profile.
  /// Not necessarily a person’s name.
  /// Typically capped at 50 characters, but subject to change.
  ///
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
  @Deprecated('Discontinue if Twitter api v2 does not provide a way to get an email.')
  String get email => _email;

  /// thumbnailImage
  String get thumbnailImage => _thumbnailImage;

  /// Twitter account name
  String get name => _name;

  /// Twitter account id
  String get screenName => _screenName;

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
        authHeader: authParams,
        apiKey: apiKey,
        apiSecretKey: apiSecretKey,
        tokenSecret: accessTokenSecret,
      );
      return User(params);
    } on Exception {
      rethrow;
    }
  }

  /// get user info.
  ///
  /// use Twitter API v2.
  ///
  /// https://api.twitter.com/2/users
  static Future<User> getUserDataV2(
    String apiKey,
    String apiSecretKey,
    String accessToken,
    String accessTokenSecret,
    String userId,
  ) async {
    try {
      final token = await Oauth2.getBearerToken(apiKey: apiKey, apiSecretKey: apiSecretKey);
      if (token?.isEmpty ?? true) {
        throw Exception();
      }

      final params = await httpGetFromBearerToken(
        '$USER_LOCKUP_URI/$userId',
        query: {'user.fields': 'id,name,username,profile_image_url'},
        bearerToken: token!,
      );

      // migrate v2 user model to v1.0a user model.
      final data = params['data'] as Map<String, dynamic>;
      data['id'] = int.parse(data['id'] as String);
      final userDict = {
        ...data,
        'profile_image_url_https': data['profile_image_url'],
        'screen_name': data['username'],
      };

      return User(userDict);
    } on Exception {
      rethrow;
    }
  }
}
