import 'package:equatable/equatable.dart';

class SingleEvent<T> extends Equatable {
  final T _value;
  var _didGet = false;

  SingleEvent(this._value) : super([_value]);

  T get value {
    if (_didGet) {
      return null;
    }
    _didGet = true;
    return _value;
  }
}
