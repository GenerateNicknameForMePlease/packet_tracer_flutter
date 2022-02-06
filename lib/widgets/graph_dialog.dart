import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packet_tracer/bloc/device_characteristic_bloc.dart';
import 'package:packet_tracer/models/device.dart';

class GraphDialog extends StatelessWidget {
  final Device device;

  const GraphDialog({this.device, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceCharacteristicBloc(id: device.id),
      child: Builder(
        builder: (context) {
          return BlocBuilder<DeviceCharacteristicBloc,
              DeviceCharacteristicState>(
            builder: (context, state) {
              if (state is LoadingDeviceCharacteristicState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final data = state.impulses;
              final List<FlSpot> a = [];
              for (var i = 0; i < data.length; i++) {
                a.add(FlSpot(i.toDouble(), data[i]));
              }
              final x = LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    colors: [
                      Colors.red,
                      Colors.orange,
                      Colors.yellow,
                      Colors.green,
                      Colors.blue,
                      Colors.purple
                    ],
                    barWidth: 1,
                    isStrokeCapRound: false,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    spots: a,
                  ),
                ],
                axisTitleData: FlAxisTitleData(
                  leftTitle: AxisTitle(
                    showTitle: true,
                    titleText: '`Значение`',
                    margin: 4,
                  ),
                  bottomTitle: AxisTitle(
                    showTitle: true,
                    margin: 20,
                    titleText: 'Отсчеты',
                    textStyle: TextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ),
              );
              return Center(
                child: Container(
                  width: 600,
                  height: 600,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        device.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Transform.scale(
                          scale: 0.9,
                          child: LineChart(x),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}
