import 'package:http/http.dart' show Client;

/// Service for making the API request to the /profile endpoint
class ProfileService {
  Client client = Client();

  /// Method to get the profile from API
  Future<String> getProfile(token) async {
    var url = Uri.parse('http://10.0.0.34:8080/profile'); // Address + endpoint
    var response = await client.get(url, headers: {"Accept": "application/json", "Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 500) {
      return "Server error";
    }
    return null;
  }

  /// Method to put changes into the API
  void putProfile(String json, String token) async {
    var url = Uri.parse('http://10.0.0.34:8080/profile'); // Address + endpoint
    await client.put(url, headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: json);
  }
}