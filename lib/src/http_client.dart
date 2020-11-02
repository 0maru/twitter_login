import 'package:http/http.dart' as http;
import 'package:twitter_login/src/signature.dart';
import 'package:twitter_login/src/utils.dart';

/// http client
class HttpClient {
  /// send method
  static Future<Map<String, dynamic>> send(
    String url,
    Map<String, dynamic> params,
    String apiKey,
    String apiSecretKey,
  ) async {
    try {
      final _signature = Signature(
        url: url,
        params: params,
        apiKey: apiKey,
        apiSecretKey: apiSecretKey,
        tokenSecretKey: '',
      );
      params['oauth_signature'] = _signature.signatureHmacSha1();
      final header = authHeader(params);
      final http.BaseClient _httpClient = http.Client();
      final http.Response res = await _httpClient.post(
        url,
        headers: <String, String>{'Authorization': header},
      );
      if (res.statusCode != 200) {
        throw Exception("Failed ${res.reasonPhrase}");
      }

      return Uri.splitQueryString(res.body);
    } on Exception catch (error) {
      throw Exception(error);
    }
  }
}
