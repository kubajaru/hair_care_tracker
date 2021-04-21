import 'dart:convert';
import 'package:hair_care_tracker/model/product.dart';
import 'package:hair_care_tracker/service/product_service.dart';

/// Controller class of my products page.
/// Provides method to get all owned products.
class MyProductsController {
  ProductService service = ProductService();

  /// Method to make API request and get all owned products.
  Future<List<Product>> getProducts(String token) async {
    List<Product> products = [];
    String json = await service.getUserProducts(token);
    if (json != null) {
      List jsonList = jsonDecode(json) as List;
      jsonList.forEach((element) {
        Product product = Product.fromJson(element);
        products.add(product);
      });
      return products;
    } else {
      return [];
    }
  }

  /// Method to make API request and save list of user products
  void saveProductsList(List<Product> products, String token) {
    String json = '[';
    products.forEach((element) {
      json = json + element.toString() + ',';
    });
    json = json.substring(0, json.length-1);
    json = json + ']';
    service.putUserProducts(token, json);
  }
}
