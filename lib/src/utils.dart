const requestTokenURI = 'https://api.twitter.com/oauth/request_token';
const authorizeURI = 'https://api.twitter.com/oauth/authorize';
const accessTokenURI = 'https://api.twitter.com/oauth/access_token';

String authHeader(Map<String, dynamic> params) {
  return 'OAuth ' +
      params.keys.map((k) {
        return '$k="${Uri.encodeComponent(params[k])}"';
      }).join(', ');
}
