import 'package:http/http.dart' as http;

abstract class IHttpService {
  Future<http.Response> post(String url, Map<String, dynamic> data);
}

class HttpServiceImpl implements IHttpService {
  @override
  Future<http.Response> post(String url, Map<String, dynamic> data) async {
    final response = await http.post(Uri.parse(url), body: data);
    return response;
  }
}
