///
const REQUSER_TOKEN_URL = 'https://api.twitter.com/oauth/request_token';

///
const AUTHORIZE_URI = 'https://api.twitter.com/oauth/authorize';

///
const ACCESS_TOKEN_URI = 'https://api.twitter.com/oauth/access_token';

///
String authHeader(Map<String, dynamic> params) {
  return 'OAuth ' +
      params.keys.map((k) {
        return '$k="${Uri.encodeComponent(params[k])}"';
      }).join(', ');
}
