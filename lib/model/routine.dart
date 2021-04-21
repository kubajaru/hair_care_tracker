import 'package:hair_care_tracker/model/product.dart';

/// Representation of Routine model
class Routine {
  List<Product> _products = <Product>[];
  String _effects;
  DateTime _date;
  String _description;
  String _name;

  Routine(this._effects, this._date, this._description, this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  String get effects => _effects;

  set effects(String value) {
    _effects = value;
  }

  List<Product> get products => _products;

  set products(List<Product> value) {
    _products = value;
  }

  Routine clone() {
    Routine newRoutine = Routine(this.effects, this.date, this.description, this.name);
    this.products.forEach((element) {
      newRoutine.products.add(element.clone());
    });
    return newRoutine;
  }

  factory Routine.fromJson(dynamic json) {
    String dateStr = json['date'] as String;
    DateTime date = DateTime.parse(dateStr);
    Routine routine = Routine(json['effects'] as String, date, json['description'] as String, json['name'] as String);
    List jsonProductsList = json['products'] as List;
    jsonProductsList.forEach((element) { 
      routine.products.add(Product.fromJson(element));
    });
    return routine;
  }

  @override
  String toString() {
    String products = '[';
    _products.forEach((element) {
      products = products + element.toString() + ',';
    });
    products = products.substring(0, products.length-1);
    products = products + '],\"user\":null';
    String dateStr = _date.toIso8601String();
    return '{\"effects\":\"$_effects\",\"date\":\"$dateStr\",\"description\":\"$_description\",\"name\":\"$_name\",\"products\":$products}';
  }
}