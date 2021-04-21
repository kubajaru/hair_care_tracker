import 'dart:convert';

import 'package:hair_care_tracker/model/profile.dart';
import 'package:test/test.dart';

void main() {
  test("JSON should be converted to Profile. ", () async {
    Map json = jsonDecode('{"profileId":2,"age":"12","length":"56","state":"Natural","porosity":"High","curlType":"2c","thickness":"Medium","denseness":"Medium","problems":"","user":null}');
    Profile profile = Profile.fromJson(json);
    expect(profile.age, "12");
    expect(profile.length, "56");
  });

  test("Profile should be converted to JSON. ", () async {
    Profile profile = Profile("12", "56", "High", "Natural", "2c", "Medium", "Medium", "");
    String json = jsonEncode(profile);
    expect(json, '{"age":"12","length":"56","porosity":"High","state":"Natural","curlType":"2c","thickness":"Medium","denseness":"Medium","problems":"","user":null}');
  });
}