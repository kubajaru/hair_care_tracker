import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/my_products_controller.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:hair_care_tracker/view/picked_product_view.dart';
import 'package:hair_care_tracker/view/search_product_view.dart';

import 'home_view.dart';

/// MyProductsView class. Here you can see your products, add and remove them.
class MyProductsView extends StatefulWidget {
  @override
  _MyProductsViewState createState() => _MyProductsViewState();
}

/// MyProductView state class. Representing state of the page.
class _MyProductsViewState extends State<MyProductsView> {
  /// List of our products.
  List<Product> _products = [];

  /// Controller object of this page.
  MyProductsController _myProductsController = MyProductsController();

  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// Build-in method to initialize the state. Used to initialize the list of
  /// products.
  @override
  void initState() {
    super.initState();
      initialize();
  }

  /// initState cannot be async so we pulled it all to separate method
  initialize() async {
    String token = await storage.read(key: "token");
      _products = await _myProductsController.getProducts(token);
      setState(() {});
  }

  /// Build-in method from State<T> class.
  /// Provides list of products with icon button to delete them, button to
  /// add product, button to save changes and button to discard changes.
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
            child: Text("My products", style: GoogleFonts.lato(fontSize: 18)),
          ),
          _productsListBuilder(),
          _addProductBtnBuilder(),
          _saveBtnBuilder(),
          Container(
              margin: const EdgeInsets.only(top: 0.0, left: 100, right: 100),
              child: Divider(
                color: Colors.black12,
                thickness: 1,
              )),
          _discardBtnBuilder(),
        ]));
  }

  /// Method to build the list of products.
  Widget _productsListBuilder() {
    return Expanded(
        child: ListView.builder(
            itemCount: _products.length * 2,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();
              final index = i ~/ 2;
              return _rowBuilder(_products[index]);
            }));
  }

  /// Method to build row of list. Provides on tap to see detailed view of
  /// product and icon button to remove it.
  Widget _rowBuilder(Product product) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PickedProductView(product),
          ),
        );
      },
      title: Text(product.name),
      subtitle: Text(product.brand),
      trailing: IconButton(
          icon: const Icon(Icons.highlight_remove),
          onPressed: () {
            setState(() {
              _products.remove(product);
            });
          }),
      tileColor: Colors.cyan.shade100,
    );
  }

  /// Method to build the add product button. After we return from view it adds
  /// product to the list.
  Widget _addProductBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 40.0, left: 80, right: 80),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text(
              "Add product",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            onPressed: () async {
              Product result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchProductView()),
              );
              setState(() {
                if (result != null) {
                  _products.add(result);
                }
              });
            },
          ),
        ));
  }

  /// Method to build Save button.
  /// Saves new list and goes to the Home page.
  Widget _saveBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, left: 80, right: 80, bottom: 5),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "Save",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              onPressed: () async {
                String token = await storage.read(key: "token");
                _myProductsController.saveProductsList(_products, token);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => HomeView()),
                      (route) => false);
              }),
        ));
  }

  /// Method to build Discard button.
  /// Goes to the Home page without saving any changes.
  Widget _discardBtnBuilder() {
    return Container(
        margin:
            const EdgeInsets.only(top: 5.0, left: 80, right: 80, bottom: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              child: Text(
                "Discard",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                    (route) => false);
              }),
        ));
  }
}
