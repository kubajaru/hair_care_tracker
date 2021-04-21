import 'package:hair_care_tracker/model/ingredient.dart';

/// Representation of Product model
class Product {
  String _name;
  String _brand;
  List<Ingredient> _ingredients = <Ingredient>[];
  int _capacity;
  String _description;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  int get capacity => _capacity;

  set capacity(int value) {
    _capacity = value;
  }

  List<Ingredient> get ingredients => _ingredients;

  set ingredients(List<Ingredient> value) {
    _ingredients = value;
  }

  String get brand => _brand;

  set brand(String value) {
    _brand = value;
  }

  Product(this._name, this._brand, this._capacity, this._description);

  Product clone() {
    Product newProduct =
        Product(this.name, this.brand, this.capacity, this.description);
    this.ingredients.forEach((element) {
      newProduct.ingredients.add(element.clone());
    });
    return newProduct;
  }

  factory Product.fromJson(dynamic json) {
    Product product = Product(json['name'] as String, json['brand'] as String, json['capacity'] as int, json['description'] as String);
    List jsonIngredients = json['ingredients'] as List;
    jsonIngredients.forEach((element) {
      product.ingredients.add(Ingredient.fromJson(element));
    });
    return product;
  }

  @override
  String toString() {
    String ingredients = '[';
    _ingredients.forEach((element) {
      ingredients = ingredients + element.toString() + ',';
    });
    ingredients = ingredients.substring(0, ingredients.length-1);
    ingredients = ingredients + '],\"users\":null';
    return '{\"name\":\"$_name\",\"brand\":\"$_brand\",\"description\":\"$_description\",\"capacity\":$_capacity,\"ingredients\":$ingredients}';
  }
}
