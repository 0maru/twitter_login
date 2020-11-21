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
  User({
    String email,
    String thumbnailImage,
    String screenName,
  })  : this._email = email,
        this._thumbnailImage = thumbnailImage,
        this._screenName = screenName;
}
