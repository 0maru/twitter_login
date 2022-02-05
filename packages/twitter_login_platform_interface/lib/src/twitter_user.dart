import 'package:quiver/core.dart';

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
