import 'dart:convert';

import 'package:hair_care_tracker/model/ingredient.dart';
import 'package:test/test.dart';

void main() {
  test("Ingredient should be converted to JSON. ", () async {
    Ingredient ingredient = Ingredient("_name", "sdfsf");
    expect(ingredient.toString(), "{\"name\":\"_name\",\"category\":\"sdfsf\"}");
  });

  test("JSON should be converted to ingredient. ", () async {
    Map json = jsonDecode("{\"name\":\"_name\",\"category\":\"sdfsf\"}");
    Ingredient ingredient = Ingredient.fromJson(json);
    expect(ingredient.name, "_name");
    expect(ingredient.category, "sdfsf");
  });
}