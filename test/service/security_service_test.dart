import 'package:hair_care_tracker/service/security_service.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  final SecurityService securityService = SecurityService();

  group('Log in', () {
    test("Token for log in should be issued. ", () async {
      securityService.client = MockClient((request) async {
        String token = "token";
        return Response(token, 200);
      });
      String result = await securityService.logInRequest("", "");
      expect(result, "token");
    });

    test("Token should not be issued. Incorrect password", () async {
      securityService.client = MockClient((request) async {
        return Response("", 200);
      });
      String result = await securityService.logInRequest("", "");
      expect(result, '');
    });

    test("Token should not be issued. Email do not exist.", () async {
      securityService.client = MockClient((request) async {
        return Response("", 400);
      });
      String result = await securityService.logInRequest("", "");
      expect(result, "Invalid email");
    });
  });

  group('Sign up', () {
    test("Token for sign up should be issued. ", () async {
      securityService.client = MockClient((request) async {
        return Response("token", 200);
      });
      String result = await securityService.signUpRequest("", "", "");
      expect(result, "token");
    });

    test("Token should not be issued. User exists", () async {
      securityService.client = MockClient((request) async {
        return Response("", 400);
      });
      String result = await securityService.signUpRequest("", "", "");
      expect(result, 'User exists');
    });

    test("Token should not be issued. Nickname taken", () async {
      securityService.client = MockClient((request) async {
        return Response("", 409);
      });
      String result = await securityService.signUpRequest("", "", "");
      expect(result, "Nickname taken");
    });
  });
}
