import 'package:hair_care_tracker/controller/sign_up_controller.dart';
import 'package:test/test.dart';

void main() {
  SignUpController controller = SignUpController();

  test("Nickname should be valid", () {
    String result = controller.validateNickname("akjsdhskaj");
    expect(result, null);
  });

  test("Nickname should not be valid. Empty", () {
    String result = controller.validateNickname("");
    expect(result, "Please, enter your nickname.");
  });

  test("Nickname should not be valid. To long", () {
    String result = controller.validateNickname("sssssssssssssssssssssss");
    expect(result, "Your nickname is too long.");
  });

  test("Email should be valid", () {
    String result = controller.validateEmail("example@example.com");
    expect(result, null);
  });

  test("Email should not be valid. Empty", () {
    String result = controller.validateEmail("");
    expect(result, "Please, enter your email.");
  });

  test("Email should not be valid. Invalid email", () {
    String result = controller.validateEmail("1232145@");
    expect(result, "Email is incorrect");
    result = controller.validateEmail("1232145@asdsa");
    expect(result, "Email is incorrect");
    result = controller.validateEmail("1232145@asdsa.");
    expect(result, "Email is incorrect");
    result = controller.validateEmail("1232145@@a.sdsa.com");
    expect(result, "Email is incorrect");
  });

  test("Password should be valid", () {
    String result = controller.validatePassword("Aa1!eeee");
    expect(result, null);
  });

  test("Password should not be valid. Empty", () {
    String result = controller.validatePassword("");
    expect(result, "Please, enter your password.");
  });

  test("Password should not be valid. No lower case", () {
    String result = controller.validatePassword("A11!1111");
    expect(result, "Incorrect password");
  });

  test("Password should not be valid. No upper case", () {
    String result = controller.validatePassword("a11!1111");
    expect(result, "Incorrect password");
  });

  test("Password should not be valid. No digit", () {
    String result = controller.validatePassword("Aa!aeeee");
    expect(result, "Incorrect password");
  });

  test("Password should not be valid. No special character", () {
    String result = controller.validatePassword("Aa1aeeee");
    expect(result, "Incorrect password");
  });

  test("Password should not be valid. Too short", () {
    String result = controller.validatePassword("Aa!ae");
    expect(result, "Incorrect password");
  });

  test("Password should not be valid. To long", () {
    String result = controller.validatePassword("Aa!aeeeesdfsgfdgjklshsdkfljgh" +
    "skdjfhakljfhdksajfhkjsdhfksadjhfkjsdhfkjsdhfsdjkh");
    expect(result, "Incorrect password");
  });

  test("Repeat password should be valid" , () {
    String result = controller.validateRepeatPassword("abcd", "abcd");
    expect(result, null);
  });

  test("Repeat password should not be valid. Empty", () {
    String result = controller.validateRepeatPassword("", "abcd");
    expect(result, "Please, enter your password.");
  });

  test("Repeat password should not be valid. Not identical passwords", () {
    String result = controller.validateRepeatPassword("abcd", "abc");
    expect(result, "Passwords are not identical");
  });

  test("Repeat password should not be valid. Null passed", () {
    String result = controller.validateRepeatPassword("abcd", null);
    expect(result, "Passwords are not identical");
  });
}