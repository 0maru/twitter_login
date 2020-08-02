class Utils {
  static const requestTokenURI = 'https://api.twitter.com/oauth/request_token';
  static const authorizeURI = 'https://api.twitter.com/oauth/authorize';
  static const accessTokenURI = 'https://api.twitter.com/oauth/access_token';

  static String authHeader(Map<String, dynamic> params) {
    return 'OAuth ' +
        params.keys.map((k) {
          return '$k="${Uri.encodeComponent(params[k])}"';
        }).join(', ');
  }
}
