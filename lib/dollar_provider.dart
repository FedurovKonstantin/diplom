import 'dart:math';

import 'package:fedurov_diplom/weather.dart';
import 'package:fedurov_diplom/dollar_manager.dart';

class DollarDataProvider {
  DollarDataProvider();

  List<Dollar> getDollars() {
    return List.generate(
      10,
      (index) => Dollar(
        65.0 - Random().nextInt(10),
      ),
    );
  }
}
