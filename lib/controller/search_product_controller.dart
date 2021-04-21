import 'dart:convert';

import 'package:hair_care_tracker/model/product.dart';
import 'package:hair_care_tracker/service/product_service.dart';

/// Controller class of search product page.
/// Provides method to get all available products.
class SearchProductController {
  ProductService service = ProductService();

  /// Method to make API request and get all available products.
  Future<List<Product>> getAvailableProducts(String token) async {
    List<Product> products = [];
    String json = await service.getDatabaseProducts(token);
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
}