import 'package:dbcrypt/dbcrypt.dart';
import 'package:hair_care_tracker/service/hash_service.dart';
import 'package:test/test.dart';

void main() {
  test("Hashed password the same as plain text", () {
    String result = HashService.hashPassword("Aa1!eeee");
    expect(new DBCrypt().checkpw("Aa1!eeee", result), true);
  });

  test("Hashed passwords are the same", () {
    String result = HashService.hashPassword("password");
    expect(result, new DBCrypt().hashpw("password", "\$2b\$12\$SDL2oZdnyEKCOPbCyoC2vu"));
  });

}