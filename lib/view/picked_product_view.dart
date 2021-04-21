import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/model/ingredient.dart';
import 'package:hair_care_tracker/model/product.dart';

/// PickedProductView class. Here you can see name, brand, capacity,
/// manufacturer's description and list of ingredients divided into the PEH
/// categories.
/// In the constructor we pass the product object to be displayed.
class PickedProductView extends StatefulWidget {
  final Product _product;

  PickedProductView(this._product);

  @override
  _PickedProductViewState createState() =>
      _PickedProductViewState(this._product);
}

/// PickedPartyView state class. Representing state of the page.
class _PickedProductViewState extends State<PickedProductView> {
  final Product _product;

  _PickedProductViewState(this._product);

  TextEditingController _descriptionController = TextEditingController();

  /// Build-in method to initialize the state. Used to set the text area with the
  /// description of the product.
  @override
  void initState() {
    super.initState();
    _descriptionController.text = _product.description;
  }

  /// Build-in method from State<T> class.
  /// Provides text, text field and list view.
  /// Return our page view as Widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hair Care Tracker", style: GoogleFonts.lato()),
        ),
        body: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Text(_product.name, style: GoogleFonts.lato(fontSize: 18)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: Text(_product.brand, style: GoogleFonts.lato(fontSize: 15)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            child: Text("${_product.capacity} ml",
                style: GoogleFonts.lato(fontSize: 12)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 15.0),
            child: Text("Manufacturer description",
                style: GoogleFonts.lato(fontSize: 16)),
          ),
          _descriptionTextAreaBuilder(),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child:
                Text("Ingredients list", style: GoogleFonts.lato(fontSize: 16)),
          ),
          _ingredientsListBuilder(),
        ]));
  }

  /// Method to build the list of ingredients.
  Widget _ingredientsListBuilder() {
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: _product.ingredients.length * 2,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();
              final index = i ~/ 2;
              return _rowBuilder(_product.ingredients[index]);
            }));
  }

  /// Method to build row of list.
  Widget _rowBuilder(Ingredient ingredient) {
    Color color = Colors.cyan.shade100;
    if (ingredient.category == "Protein") {
      color = Colors.green.shade100;
    } else if (ingredient.category == "Emolient") {
      color = Colors.yellow.shade100;
    }
    return ListTile(
      title: Text(
        ingredient.name,
        style: TextStyle(fontSize: 15),
      ),
      subtitle: Text(
        ingredient.category,
        style: TextStyle(fontSize: 12),
      ),
      tileColor: color,
      dense: true,
    );
  }

  /// Method to build the text area for description.
  Widget _descriptionTextAreaBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 0.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        style: TextStyle(fontSize: 13),
        controller: _descriptionController,
        minLines: 2,
        maxLines: 4,
        readOnly: true,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            )),
      ),
    );
  }

  /// Build-in method to free up resources when view is not visible.
  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }
}
