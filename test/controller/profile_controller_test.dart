import 'package:hair_care_tracker/controller/profile_controller.dart';
import 'package:test/test.dart';

void main() {
  ProfileController controller = ProfileController();

  test("Age should be valid", () {
    String result = controller.validateAge("23");
    expect(result, null);
  });

  test("Age should not be valid. Empty", () {
    String result = controller.validateAge("");
    expect(result, "This field cannot be empty!");
  });

  test("Age should not be valid. Less then 10", () {
    String result = controller.validateAge("1");
    expect(result, "Your age must be between 10 and 99!");
  });
}