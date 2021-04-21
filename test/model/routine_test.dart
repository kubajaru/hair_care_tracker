import 'dart:convert';

import 'package:hair_care_tracker/model/ingredient.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:hair_care_tracker/model/routine.dart';
import 'package:test/test.dart';

void main() {
  test("Routine should be converted to JSON. ", () {
    DateTime date = DateTime.now();
    Routine routine = Routine("_effects", date, "_description", "_name");
    Product product = Product("name", "sdfds", 21, "sdfsfs");
    Ingredient ingredient = Ingredient("_name", "sdfsf");
    product.ingredients.add(ingredient);
    routine.products.add(product);
    expect(routine.toString(), "{\"effects\":\"_effects\",\"date\":\"${date.toIso8601String()}\",\"description\":\"_description\",\"name\":\"_name\",\"products\":[{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}],\"user\":null}");
  });

  test("JSON should be converted to Routine. ", () {
    DateTime date = DateTime.now();
    Map json = jsonDecode("{\"effects\":\"_effects\",\"date\":\"${date.toIso8601String()}\",\"description\":\"_description\",\"name\":\"_name\",\"products\":[{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}],\"user\":null}");
    Routine routine = Routine.fromJson(json);
    expect(routine.name, "_name");
    expect(routine.description, "_description");
    expect(routine.date, date);
    expect(routine.effects, "_effects");
    expect(routine.products[0].name, "name");
  });
}