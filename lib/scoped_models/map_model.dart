import 'package:scoped_model/scoped_model.dart';
import '../models/location.dart';

mixin LocationModel on Model {
  Location _currentLocation;

  Location get currentLocation {
    return _currentLocation;
  }

  set currentLocation(Location loc) {
    _currentLocation = loc;
    notifyListeners();
  }
}
