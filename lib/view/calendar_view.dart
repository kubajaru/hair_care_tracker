import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hair_care_tracker/controller/calendar_controller.dart';
import 'package:hair_care_tracker/model/routine.dart';
import 'package:hair_care_tracker/view/routine_view.dart';
import 'package:table_calendar/table_calendar.dart';

/// CalendarView class. Here you create or edit routines.
class CalendarView extends StatefulWidget {
  @override
  _CalendarViewState createState() => _CalendarViewState();
}

/// CalendarView state class. Representing state of the page.
class _CalendarViewState extends State<CalendarView> {
  /// Representation of events at given date. Implementation required by plugin.
  Map<DateTime, List> _events = {};

  /// Controller of secure storage.
  final storage = new FlutterSecureStorage();

  /// List of user routines. It is pull from the API.
  List<Routine> routines;
  /// Controller of the calendar widget. Required by the plugin.
  CalendarController calendarController = CalendarController();
  /// Controller object of this page.
  CalendarViewController _calendarViewController = CalendarViewController();

  /// Build-in method to initialize the list of routines and map of events.
  @override
  void initState() {
    super.initState();
    initialize();
  }

  /// initState cannot be async so we pulled it all to separate method
  initialize() async {
    String token = await storage.read(key: "token");
    routines = await _calendarViewController.getRoutines(token);
    routines.forEach((element) {
      _events.addAll({
        element.date: [element]
      });
    });
    setState(() {});
  }

  /// Build-in method from State<T> class.
  /// Provides calendar view to edit and add routines.
  /// Return our page view as Widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hair Care Tracker", style: GoogleFonts.lato()),
        ),
        body: Column(children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 90.0),
            child: Text("Calendar", style: GoogleFonts.lato(fontSize: 18)),
          ),
          _calendarBuilder(),
        ]));
  }

  /// Method to build the calendar view. If routine do not exist it creates it,
  /// else it passes the routine to be edited in the Routine View.
  Widget _calendarBuilder() {
    return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: TableCalendar(
      calendarController: calendarController,
      events: _events,
      onDaySelected: (date, events, holidays) async {
        Routine result; // null
        if (events.isEmpty) {
          Routine start = Routine("", date, "", "");
          result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => RoutineView(start)));
        } else {
          result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => RoutineView(events[0].clone())));
        }
        setState(() {
          if (result != null) {
            _events.addAll({result.date: [result]});
          }
        });

      },
    ));
  }

  /// Build-in method to free up resources when view is not visible.
  @override
  void dispose() {
    super.dispose();
    calendarController.dispose();
  }
}
