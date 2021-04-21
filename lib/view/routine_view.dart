import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/routine_controller.dart';
import 'package:hair_care_tracker/model/product.dart';
import 'package:hair_care_tracker/model/routine.dart';
import 'package:hair_care_tracker/view/owned_products_view.dart';
import 'package:hair_care_tracker/view/picked_product_view.dart';
import 'package:add_2_calendar/add_2_calendar.dart';

/// RoutineView class. Here you edit and save your routine. Also add
/// used products from owned products.
/// Takes [_routine] from the Calendar.
class RoutineView extends StatefulWidget {
  final Routine _routine;

  RoutineView(this._routine);

  @override
  _RoutineViewState createState() => _RoutineViewState(_routine);
}

/// RoutineView state class. Representing state of the page.
/// Takes the [_routine] from the RoutineView class.
class _RoutineViewState extends State<RoutineView>
    with TickerProviderStateMixin {
  Routine _routine;

  _RoutineViewState(this._routine);

  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _effectsController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  RoutineController _routineController = RoutineController();
  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// Controller of tabs.
  TabController _tabController;

  /// List of our products.
  List<Product> _products = <Product>[];

  /// Build-in method to initialize the state. Used to initialize the list of
  /// products.
  @override
  void initState() {
    super.initState();
    _products = _routine.products;
    _descriptionController.text = _routine.description;
    _nameController.text = _routine.name;
    _effectsController.text = _routine.effects;
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  /// Listener to fire set state when changing the tabs. Firing state
  /// changes the floating action button.
  void _handleTabIndex() {
    setState(() {});
  }

  /// Build-in method from State<T> class.
  /// Provides two tabs. On first you can edit the details of routine.
  /// On the second add products.
  /// Return our page view as Widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hair Care Tracker", style: GoogleFonts.lato()),
        bottom: TabBar(controller: _tabController, tabs: const <Widget>[
          Tab(
            icon: Icon(Icons.description),
            text: "Details",
          ),
          Tab(
            icon: Icon(Icons.science),
            text: "Products",
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          detailsTab(),
          productsTab(),
        ],
      ),
      floatingActionButton: _bottomButtons(),
    );
  }

  /// Method to build the details tab.
  Widget detailsTab() {
    return Column(
      children: [
        _nameTextFieldBuilder(),
        _descriptionTextAreaBuilder(),
        _effectsTextAreaBuilder(),
      ],
    );
  }

  /// Method to build the products tab.
  Widget productsTab() {
    return Column(
      children: [
        _productsListBuilder(),
      ],
    );
  }

  /// Method to create appropriate floating action button.
  Widget _bottomButtons() {
    return _tabController.index == 0
        ? FloatingActionButton.extended(
            label: Text("Save", style: TextStyle(fontSize: 18)),
            backgroundColor: Colors.cyan.shade300,
            icon: Icon(Icons.check),

            /// Function to save the changes.
            onPressed: () async {
              String name = _nameController.text.toString();
              String desc = _descriptionController.text.toString();
              String effects = _effectsController.text.toString();

              if (name.isNotEmpty && desc.isNotEmpty) {
                _routine.name = name;
                _routine.description = desc;
                _routine.effects = effects;
                String token = await storage.read(key: "token");
                _routineController.saveRoutine(token, _routine);
                addEvent();
                Navigator.pop(context, _routine);
              }
            },
          )
        : FloatingActionButton.extended(
            label: Text("Add", style: TextStyle(fontSize: 18)),
            backgroundColor: Colors.purple.shade300,
            icon: Icon(Icons.add),

            /// Function goes to the owned products page to get product.
            onPressed: () async {
              Product result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OwnedProductsView()),
              );
              setState(() {
                if (result != null) {
                  _products.add(result);
                }
              });
            },
          );
  }

  /// Method to add event to the calendar
  void addEvent() {
    final Event event = Event(
        title: _routine.name,
        description: _routine.description,
        startDate: _routine.date,
        endDate: _routine.date.add(Duration(hours: 1)));
    Add2Calendar.addEvent2Cal(event);
  }

  /// Method to build the text field for routine name.
  Widget _nameTextFieldBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 20.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        style: TextStyle(fontSize: 13),
        controller: _nameController,
        maxLength: 40,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.isEmpty) {
            return "Name is very important. Name your routine";
          }
          return null;
        },
        decoration: InputDecoration(hintText: "Name"),
        maxLengthEnforced: true,
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[a-z A-Z]"))
        ],
      ),
    );
  }

  /// Method to build the text area for effects. Do not have to be filled.
  Widget _effectsTextAreaBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        style: TextStyle(fontSize: 13),
        controller: _effectsController,
        minLines: 3,
        maxLines: 6,
        maxLength: 400,
        maxLengthEnforced: true,
        decoration: InputDecoration(hintText: "Describe effects"),
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[a-zA-Z0-9., -]"))
        ],
      ),
    );
  }

  /// Method to build the text area for description.
  Widget _descriptionTextAreaBuilder() {
    return Container(
      margin: const EdgeInsets.only(top: 15.0, left: 20, right: 20, bottom: 0),
      child: TextFormField(
        style: TextStyle(fontSize: 13),
        controller: _descriptionController,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (value.isEmpty) {
            return "Provide some description";
          }
          return null;
        },
        minLines: 3,
        maxLines: 6,
        maxLength: 400,
        maxLengthEnforced: true,
        decoration: InputDecoration(hintText: "Describe routine"),
        keyboardType: TextInputType.name,
        inputFormatters: [
          FilteringTextInputFormatter.allow(new RegExp("[a-zA-Z0-9., -]"))
        ],
      ),
    );
  }

  /// Method to build the list of products.
  Widget _productsListBuilder() {
    return Expanded(
        child: ListView.builder(
            itemCount: _products.length * 2,
            shrinkWrap: true,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();
              final index = i ~/ 2;
              return _rowBuilder(_products[index]);
            }));
  }

  /// Method to build row of list. Provides remove Icon button.
  Widget _rowBuilder(Product product) {
    return ListTile(
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
        trailing: IconButton(
            icon: const Icon(Icons.highlight_remove),
            onPressed: () {
              setState(() {
                _products.remove(product);
              });
            }));
  }

  /// Build-in method to free up resources when view is not visible.
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _effectsController.dispose();
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
  }
}
