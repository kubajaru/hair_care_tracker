import 'package:hair_care_tracker/controller/my_products_controller.dart';
import 'package:hair_care_tracker/model/ingredient.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final MyProductsController controller = MyProductsController();

  test("Get all user products as objects ", () async {
    controller.service.client = MockClient((request) async {
      return Response(
          "[{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null},{\"name\":\"name1\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}]",
          200);
    });
    List<Product> products = await controller.getProducts("token");
    expect(products.length, 2);
    expect(products[0].name, "name");
    expect(products[1].name, "name1");
  });

  test("Put all user products as JSON ", () async {
    controller.service.client = MockClient((request) async {
      expect(request.body,
          "[{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null},{\"name\":\"name1\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}]");
      return Response("", 200);
    });
    List<Product> products = [];
    Product product = Product("name", "sdfds", 21, "sdfsfs");
    Product product1 = Product("name1", "sdfds", 21, "sdfsfs");
    Ingredient ingredient = Ingredient("_name", "sdfsf");
    product.ingredients.add(ingredient);
    product1.ingredients.add(ingredient);
    products.add(product);
    products.add(product1);
    controller.saveProductsList(products, "token");
  });
}
