import 'package:http/http.dart' as http;
import 'dart:convert';

// makes a network request & returns json object if successful
class NetworkHelper {
  final String url;

  NetworkHelper(this.url);

  Future getReq(customHeaders) async {
    http.Response response =
        await http.get(Uri.parse(url), headers: customHeaders);
    return handleResponse(response);
  }

  Future postReq(customHeader, customBody) async {
    http.Response response = await http.post(Uri.parse(url),
        headers: customHeader, body: customBody);
    return handleResponse(response);
  }

  dynamic handleResponse(http.Response response) {
    String data = response.body;
    var decodedData = jsonDecode(data);
    if (response.statusCode != 200) {
      print(response.statusCode);
      print(data);
    }
    return decodedData;
  }
}
