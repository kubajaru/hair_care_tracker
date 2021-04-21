/// Representation of Profile model.
class Profile {
  String _age;
  String _length;
  String _porosity;
  String _state;
  String _curlType;
  String _thickness;
  String _denseness;
  String _problems;


  Profile(this._age, this._length, this._porosity, this._state, this._curlType,
      this._thickness, this._denseness, this._problems);

  String get problems => _problems;

  String get denseness => _denseness;

  String get thickness => _thickness;

  String get curlType => _curlType;

  String get porosity => _porosity;

  String get length => _length;

  String get age => _age;

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  @override
  String toString() {
    return 'Profile{_age: $_age, _length: $_length, _porosity: $_porosity, _curlType: $_curlType, _thickness: $_thickness, _denseness: $_denseness, _problems: $_problems}';
  }

  Profile.fromJson(Map<String, dynamic> json)
      : _age = json['age'],
        _length = json['length'],
        _porosity = json['porosity'],
        _state = json['state'],
        _curlType = json['curlType'],
        _thickness = json['thickness'],
        _denseness = json['denseness'],
        _problems = json['problems'];

  Map<String, dynamic> toJson() =>
      {
        'age': _age,
        'length': _length,
        'porosity': _porosity,
        'state': _state,
        'curlType': _curlType,
        'thickness': _thickness,
        'denseness': _denseness,
        'problems': _problems,
        'user': null
      };
}
