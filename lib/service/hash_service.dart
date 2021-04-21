import 'package:dbcrypt/dbcrypt.dart';

/// Service with static method to hash our password.
class HashService {
  static String hashPassword(String password) {
    // We hardcode salt for easier hashing. Not the best way to handle it.
    return new DBCrypt().hashpw(password, "\$2b\$12\$SDL2oZdnyEKCOPbCyoC2vu");
  }
}