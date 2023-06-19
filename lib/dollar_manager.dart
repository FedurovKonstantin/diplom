import 'dart:async';

import 'package:fedurov_diplom/weather.dart';

import 'dollar_provider.dart';

class DollarManager {
  final DollarDataProvider _dataProvider;

  DollarManager(this._dataProvider);

  final _viewTypeController = StreamController<ViewType>.broadcast();
  Stream<ViewType> viewType() => _viewTypeController.stream;
  void onSelectViewType(ViewType type) => _viewTypeController.add(type);

  final _chartViewTypeController = StreamController<ChartViewType>.broadcast();
  Stream<ChartViewType> dataSize() => _chartViewTypeController.stream;
  void onSelectDataSize(ChartViewType type) =>
      _chartViewTypeController.add(type);

  get _dollarController => StreamController<List<Dollar>>()
    ..add(
      _dataProvider.getDollars(),
    );

  Stream<List<Dollar>> dollars() => _dollarController.stream;
}

enum ViewType {
  flutter,
  native,
}

enum ChartViewType {
  month,
  year,
  day,
}
