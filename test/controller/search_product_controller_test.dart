import 'package:hair_care_tracker/controller/search_product_controller.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  SearchProductController controller = SearchProductController();
  test("Get product from the database. ", () async {
    controller.service.client = MockClient((request) async {
      return Response("[{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null},{\"name\":\"name1\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}]", 200);
    });
    List<Product> products = await controller.getAvailableProducts("token");
    expect(products.length, 2);
    expect(products[0].name, "name");
    expect(products[1].name, "name1");
  });
}
