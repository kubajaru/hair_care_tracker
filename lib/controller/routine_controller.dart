import 'package:hair_care_tracker/model/routine.dart';
import 'package:hair_care_tracker/service/routine_service.dart';

/// Controller responsible for saving the modifications to the routine
class RoutineController {
  RoutineService service = RoutineService();

  /// Method to save changes on the routine to the API
  void saveRoutine(String token, Routine routine) async {
    String json = routine.toString();
    service.putRoutine(token, json);
  }

}