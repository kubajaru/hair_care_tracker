import 'package:hair_care_tracker/controller/calendar_controller.dart';
import 'package:hair_care_tracker/model/routine.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final CalendarViewController calendarViewController = CalendarViewController();

  test("Get all routines as objects ", () async {
    DateTime date = DateTime.now();
    calendarViewController.routineService.client = MockClient((request) async {
      return Response("[{\"effects\":\"_effects\",\"date\":\"${date.toIso8601String()}\",\"description\":\"_description\",\"name\":\"_name\",\"products\":[{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}],\"user\":null}, {\"effects\":\"_effects\",\"date\":\"${date.toIso8601String()}\",\"description\":\"_description\",\"name\":\"_name1\",\"products\":[{\"name\":\"name\",\"brand\":\"sdfds\",\"description\":\"sdfsfs\",\"capacity\":21,\"ingredients\":[{\"name\":\"_name\",\"category\":\"sdfsf\"}],\"users\":null}],\"user\":null}]", 200);
    });
    List<Routine> routines = await calendarViewController.getRoutines("token");
    expect(routines.length, 2);
    expect(routines[0].name, "_name");
    expect(routines[1].name, "_name1");
  });
}

