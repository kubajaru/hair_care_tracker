import 'package:http/http.dart' show Client;

/// Service for making API request to the /routines endpoint.
class RoutineService {
  Client client = Client();

  /// Method to get routines from the API.
  Future<String> getUserRoutines(String token) async {
    var url = Uri.parse('http://10.0.0.34:8080/routines'); // Address + endpoint
    var response = await client.get(url, headers: {"Accept": "application/json", "Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  /// Method to put changes to the routine to the API.
  void putRoutine(String token, String json) async {
    var url = Uri.parse('http://10.0.0.34:8080/routines'); // Address + endpoint
    var response = await client.put(url, headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: json);
  }
}