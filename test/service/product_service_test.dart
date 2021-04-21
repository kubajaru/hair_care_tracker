import 'package:hair_care_tracker/service/product_service.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final ProductService service = ProductService();

  test("Correct GET request for the /products endpoint should be issued. ", () async {
    service.client = MockClient((request) async {
      expect(request.method, "GET");
      expect(request.headers["Authorization"], "Bearer token");
      return Response("", 200);
    });
    String result = await service.getDatabaseProducts("token");
    expect(result, "");
  });

  test("Correct GET request for the /userproducts endpoint should be issued. ", () async {
    service.client = MockClient((request) async {
      expect(request.method, "GET");
      expect(request.headers["Authorization"], "Bearer token");
      return Response("", 200);
    });
    String result = await service.getUserProducts("token");
    expect(result, "");
  });

  test("Correct PUT request for the /userproducts endpoint should be issued. ", () async {
    service.client = MockClient((request) async {
      expect(request.method, "PUT");
      expect(request.headers["Authorization"], "Bearer token");
      expect(request.body, "json");
      return Response("", 200);
    });
    service.putUserProducts("token", "json");
  });
}