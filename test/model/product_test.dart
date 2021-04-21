import 'dart:convert';

import 'package:hair_care_tracker/model/ingredient.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:test/test.dart';

void main() {
  test("Product should be converted to JSON. ", () {
   Product product = Product("name", "sdfds", 21, "sdfsfs");
   Ingredient ingredient = Ingredient("_name", "sdfsf");
   product.ingredients.add(ingredient);
   expect(product.toString(), "{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}");
  });

  test("JSON should be converted to Product. ", () {
    Map json = jsonDecode("{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}");
    Product product = Product.fromJson(json);
    expect(product.name, "name");
    expect(product.brand, "sdfds");
    expect(product.description, "sdfsfs");
    expect(product.capacity, 21);
    expect(product.ingredients[0].name, "_name");
    expect(product.ingredients[0].category, "sdfsf");
  });
}