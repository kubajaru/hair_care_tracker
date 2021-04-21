import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/my_products_controller.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:hair_care_tracker/view/picked_product_view.dart';

/// OwnedProductsView class. Here you choose products for the routine.
class OwnedProductsView extends StatefulWidget {
  @override
  _OwnedProductsViewState createState() => _OwnedProductsViewState();
}
/// OwnedProductsView state class. Representing state of the page.
class _OwnedProductsViewState extends State<OwnedProductsView> {

  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  MyProductsController _myProductsController = MyProductsController();
  /// List of our products.
  List<Product> _products=<Product>[];

  /// Build-in method to initialize the state. Used to initialize the list of
  /// products.
  @override
  void initState() {
    super.initState();
    initialize();
  }

  /// initState cannot be async so we pulled it all to separate method
  initialize() async{
    String token = await storage.read(key: "token");
    _products = await _myProductsController.getProducts(token);
    setState(() {});
  }

  /// Build-in method from State<T> class.
  /// Provides list of owned products with on tap to choose and long press for
  /// detailed view.
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
            child: Text("Owned products", style: GoogleFonts.lato(fontSize: 18)),
          ),
          _productsListBuilder()
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

  /// Method to build row of list. Provides on tap to choose the product and
  /// on long press to see the detailed view.
  Widget _rowBuilder(Product product) {
    return ListTile(
      onTap: () {
        Navigator.pop(context, product);
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PickedProductView(product),
          ),
        );
      },
      title: Text(product.name),
      subtitle: Text(product.brand),
      tileColor: Colors.cyan.shade100,
    );
  }
}
