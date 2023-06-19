import 'dart:convert';

import 'package:d_chart/d_chart.dart';
import 'package:fedurov_diplom/dollar_provider.dart';
import 'package:fedurov_diplom/profile_page.dart';
import 'package:fedurov_diplom/dollar_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'chart_view.dart';

final dollarProvider = DollarDataProvider();
final dollarManager = DollarManager(dollarProvider);

void main() {
  runApp(
    RootWidget(),
  );
}

class RootWidget extends StatefulWidget {
  RootWidget({super.key});

  @override
  State<RootWidget> createState() => _RootWidgetState();
}

class _RootWidgetState extends State<RootWidget> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'График',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            ),
          ],
          onTap: (value) => setState(() {
            currentTab = value;
          }),
        ),
        body: SafeArea(
          child: [
            ChartPage(),
            ProfilePage(),
          ][currentTab],
        ),
      ),
    );
  }
}

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Курс доллара'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const ViewTypeSettings(),
              // StreamBuilder(
              //   stream: Stream.periodic(
              //     Duration(
              //       milliseconds: 10,
              //     ),
              //     (value) => value,
              //   ),
              //   builder: (context, snapshot) => Text('${snapshot.data}'),
              // ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.withOpacity(0.05),
                  ),
                  child: StreamBuilder<List<Enum>>(
                    stream: Rx.combineLatest2(
                      dollarManager.viewType().startWith(ViewType.native),
                      dollarManager.dataSize().startWith(ChartViewType.day),
                      (a, b) => [a, b],
                    ),
                    initialData: const [
                      ViewType.native,
                      ChartViewType.day,
                    ],
                    builder: (context, snapshot) {
                      final viewType = snapshot.data![0] as ViewType;
                      final chartViewType = snapshot.data![1] as ChartViewType;

                      final data = dollarProvider.getDollars();

                      // switch (viewType) {
                      // case ViewType.flutter:
                      // return DChartLine(
                      //   animate: false,
                      //   data: [
                      //     {
                      //       'id': 'Line',
                      //       'data': [
                      //         for (int i = 0; i < data.length; i++)
                      //           {'domain': i, 'measure': data[i].value},
                      //       ],
                      //     },
                      //   ],
                      //   lineColor: (lineData, index, id) => Colors.amber,
                      // );
                      // return FlutterChartView(
                      //   data: data.map((e) => e.value),
                      // );
                      // return LineChart(
                      //   LineChartData(
                      //     lineBarsData: [
                      //       LineChartBarData(
                      //         spots: [
                      //           for (int i = 0; i < data.length; i++)
                      //             FlSpot(
                      //               i.toDouble(),
                      //               data[i].value,
                      //             )
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // );
                      // case ViewType.native:
                      return NativeView(
                        viewType: chartViewType,
                      );
                      // }
                    },
                  ),
                ),
              ),
              const DataSizeSettings(),
            ],
          ),
        ),
      ),
    );
  }
}

class NativeView extends StatefulWidget {
  final ChartViewType viewType;

  const NativeView({
    required this.viewType,
    super.key,
  });

  @override
  State<NativeView> createState() => _NativeViewState();
}

class _NativeViewState extends State<NativeView> {
  static const channel = MethodChannel('native_view_chart/data');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  void loadData() {
    channel.invokeMethod(
      'data',
      jsonEncode(
        dollarProvider.getDollars(),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant NativeView oldWidget) {
    if (oldWidget.viewType != widget.viewType) {
      loadData();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = 'native_view_chart';

    return PlatformViewLink(
      viewType: viewType,
      surfaceFactory: (context, controller) {
        return AndroidViewSurface(
          controller: controller as AndroidViewController,
          gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
          hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        );
      },
      onCreatePlatformView: (params) {
        return PlatformViewsService.initSurfaceAndroidView(
          id: params.id,
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: widget.viewType.name,
          creationParamsCodec: const StandardMessageCodec(),
          onFocus: () {
            params.onFocusChanged(true);
          },
        )
          ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
          ..create();
      },
    );
  }
}

class ViewTypeSettings extends StatelessWidget {
  const ViewTypeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Тип компоненты",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<ViewType>(
          stream: dollarManager.viewType(),
          initialData: ViewType.flutter,
          builder: (
            BuildContext context,
            AsyncSnapshot<ViewType> snapshot,
          ) {
            return CupertinoSlidingSegmentedControl<ViewType>(
              children: const {
                ViewType.native: Text('Native'),
                ViewType.flutter: Text('Flutter'),
              },
              groupValue: snapshot.data,
              onValueChanged: (value) {
                dollarManager.onSelectViewType(value!);
              },
            );
          },
        ),
      ],
    );
  }
}

class DataSizeSettings extends StatelessWidget {
  const DataSizeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Период",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        StreamBuilder<ChartViewType>(
          stream: dollarManager.dataSize(),
          initialData: ChartViewType.day,
          builder: (
            BuildContext context,
            AsyncSnapshot<ChartViewType> snapshot,
          ) {
            return CupertinoSlidingSegmentedControl<ChartViewType>(
              children: const {
                ChartViewType.day: Text('День'),
                ChartViewType.month: Text('Месяц'),
                ChartViewType.year: Text('Год'),
              },
              groupValue: snapshot.data,
              onValueChanged: (value) {
                dollarManager.onSelectDataSize(value!);
              },
            );
          },
        ),
      ],
    );
  }
}
