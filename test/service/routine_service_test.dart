import 'package:hair_care_tracker/service/routine_service.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  RoutineService service = RoutineService();

  test("Correct GET request for the /routines endpoint should be issued. ", () async {
    service.client = MockClient((request) async {
      expect(request.method, "GET");
      expect(request.headers["Authorization"], "Bearer token");
      return Response("", 200);
    });
    String result = await service.getUserRoutines("token");
    expect(result, "");
  });

  test("Correct PUT request for the /routines endpoint should be issued. ", () async {
    service.client = MockClient((request) async {
      expect(request.method, "PUT");
      expect(request.headers["Authorization"], "Bearer token");
      expect(request.body, "json");
      return Response("", 200);
    });
    service.putRoutine("token", "json");
  });
}