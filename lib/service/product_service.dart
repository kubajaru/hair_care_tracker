import 'package:http/http.dart' show Client;

/// Service to make API request connected with product endpoints.
class ProductService {
  Client client = Client();

  /// Method to make GET request to /products endpoint to get all products.
  Future<String> getDatabaseProducts(String token) async {
    var url = Uri.parse('http://10.0.0.34:8080/products'); // Address + endpoint
    var response = await client.get(url, headers: {"Accept": "application/json", "Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  /// Method to make GET request to /userproducts endpoint to get all user products.
  Future<String> getUserProducts(String token) async {
    var url = Uri.parse('http://10.0.0.34:8080/userproducts'); // Address + endpoint
    var response = await client.get(url, headers: {"Accept": "application/json", "Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
  }

  /// Method to make PUT request to /userproducts endpoint to get all user products.
  void putUserProducts(String token, String json) async {
    var url = Uri.parse('http://10.0.0.34:8080/userproducts'); // Address + endpoint
    await client.put(url, headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"}, body: json);
  }
}