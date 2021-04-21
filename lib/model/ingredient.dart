/// Representation of ingredient model
class Ingredient {
  String _name;
  String _category;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  Ingredient(this._name, this._category);

  Ingredient clone() {
    return Ingredient(this.name, this.category);
  }

  Ingredient.fromJson(Map<String, dynamic> json)
      : _name = json['name'],
        _category = json['category'];

  @override
  String toString() {
    return '{\"name\":\"$_name\",\"category\":\"$_category\"}';
  }
}
