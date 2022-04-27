import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_login/schemes/access_token.dart';

void main() {
  group('access token json parse test', () {
    test('parse', () {
      final json = {
        'oauth_token': 'oauth_token',
        'oauth_token_secret': 'oauth_token_secret',
        'user_id': 'user_id',
        'screen_name': 'screen_name',
      };

      final accessToken = AccessToken(json);
      // ignore: unnecessary_type_check
      expect(accessToken is AccessToken, isTrue);
    });

    test('all null', () {
      final json = {
        'oauth_token': null,
        'oauth_token_secret': null,
        'user_id': null,
        'screen_name': null,
      };

      final accessToken = AccessToken(json);
      // ignore: unnecessary_type_check
      expect(accessToken is AccessToken, isTrue);
    });

    test('all undefined', () {
      final json = <String, dynamic>{};

      final accessToken = AccessToken(json);
      // ignore: unnecessary_type_check
      expect(accessToken is AccessToken, isTrue);
    });
  });
}
