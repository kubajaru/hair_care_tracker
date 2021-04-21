import 'dart:convert';

import 'package:hair_care_tracker/model/routine.dart';
import 'package:hair_care_tracker/service/routine_service.dart';

/// Controller class of calendar page.
/// Provides method to get all routines.
class CalendarViewController {
  RoutineService routineService = RoutineService();

  /// Method to make API request and get all user routines.
  Future<List<Routine>> getRoutines(String token) async {
    List<Routine> routines = [];
    String json = await routineService.getUserRoutines(token);
    if (json != null) {
      List jsonList = jsonDecode(json) as List;
      jsonList.forEach((element) {
        Routine routine = Routine.fromJson(element);
        routines.add(routine);
      });
      return routines;
    } else {
      return [];
    }
  }
}