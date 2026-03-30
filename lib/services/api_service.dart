import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static String baseUrl = "https://dalel-el-salehiya-production.up.railway.app";

  // 🔥 headers
  static Future<Map<String, String>> _headers({bool isJson = false}) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";

    return {
      if (isJson) "Content-Type": "application/json",
      "Authorization": token,
    };
  }

  // 🔥 handle response
  static dynamic _handleResponse(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) {
      if (res.body.isNotEmpty) {
        return jsonDecode(res.body);
      }
      return null;
    } else {
      throw Exception("API Error: ${res.statusCode} - ${res.body}");
    }
  }

  // 🔥 build url (حل مشكلة /)
  static Uri _buildUrl(String endpoint) {
    return Uri.parse("$baseUrl/${endpoint.replaceFirst("/", "")}");
  }

  // 🔥 GET
  static Future get(String endpoint) async {
    final res = await http.get(
      _buildUrl(endpoint),
      headers: await _headers(),
    );

    return _handleResponse(res);
  }

  // 🔥 POST
  static Future post(String endpoint, Map body) async {
    final res = await http.post(
      _buildUrl(endpoint),
      headers: await _headers(isJson: true),
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  // 🔥 PUT
  static Future put(String endpoint, Map body) async {
    final res = await http.put(
      _buildUrl(endpoint),
      headers: await _headers(isJson: true),
      body: jsonEncode(body),
    );

    return _handleResponse(res);
  }

  // 🔥 DELETE
  static Future delete(String endpoint) async {
    final res = await http.delete(
      _buildUrl(endpoint),
      headers: await _headers(),
    );

    return _handleResponse(res);
  }

  // 🔥 UPLOAD IMAGE (FIXED 🔥)
  static Future<String?> uploadImage(Uint8List bytes) async {
    final request = http.MultipartRequest(
      "POST",
      _buildUrl("/upload"),
    );

    request.headers.addAll(await _headers());

    request.files.add(
      http.MultipartFile.fromBytes(
        "image",
        bytes,
        filename: "image.jpg",
      ),
    );

    final streamedResponse = await request.send();

    final bytesResponse = await streamedResponse.stream.toBytes();

    final res = http.Response.bytes(
      bytesResponse,
      streamedResponse.statusCode,
    );

    final data = _handleResponse(res);

    return data?["url"];
  }
}
