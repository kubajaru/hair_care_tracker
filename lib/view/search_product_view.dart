import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/search_product_controller.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:hair_care_tracker/view/picked_product_view.dart';


/// SearchProductView class. Here you get all available products and search
/// through them.
class SearchProductView extends StatefulWidget {
  @override
  _SearchProductViewState createState() => _SearchProductViewState();
}

/// SearchProductView state class. Representing state of the page.
class _SearchProductViewState extends State<SearchProductView> {
  TextEditingController _searchController = TextEditingController();

  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// List of available products.
  List<Product> _products;

  /// List of products to be displayed.
  List<Product> _productsToShow = <Product>[];

  /// Controller object of this page.
  SearchProductController controller = SearchProductController();

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
    _products = await controller.getAvailableProducts(token);
    setState(() {
      _products.forEach((element) {
        _productsToShow.add(element.clone());
      });
    });

  }

  /// Build-in method from State<T> class.
  /// Provides text form field to input the name, button to search by name of
  /// the product and the list of products.
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
            child:
                Text("Search product", style: GoogleFonts.lato(fontSize: 18)),
          ),
          _searchTextFieldBuilder(),
          _searchBtnBuilder(),
          Container(
              margin: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
              child: Divider(
                color: Colors.black12,
                thickness: 1,
              )),
          _productsListBuilder(),
        ]));
  }

  /// Method to build the search text field. Allows only lower, upper case,
  /// digit and dash.
  Widget _searchTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        decoration: InputDecoration(hintText: "Name of the product"),
        controller: _searchController,
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[a-zA-Z0-9-]"))
        ],
      ),
    );
  }

  /// Method to build search button.
  Widget _searchBtnBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 20.0, left: 80, right: 80),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            child: Text("Search"),
            onPressed: () {
              setState(() {
                String pattern = _searchController.text.toString();
                search(pattern);
              });
            },
          ),
        ));
  }

  /// Method to search through the list of products.
  void search(String pattern) {
    _productsToShow.clear();
    _products.forEach((element) {
      if (element.name.startsWith(pattern)) {
        _productsToShow.add(element.clone());
      }
    });
  }

  /// Method to build the list of products.
  Widget _productsListBuilder() {
    return Expanded(
        child: ListView.builder(
            itemCount: _productsToShow.length * 2,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();
              final index = i ~/ 2;
              return _rowBuilder(_productsToShow[index]);
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
