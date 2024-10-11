import 'package:flutter/material.dart';
import 'package:fuellevel_monitoring/config/asset_config.dart';
import 'package:fuellevel_monitoring/config/color.dart';
import 'package:fuellevel_monitoring/widget/fueltank_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controller/fuel_controller.dart';

class TankDetailPage extends StatefulWidget {
  final int tankIndex;
  const TankDetailPage({super.key, required this.tankIndex});

  @override
  State<TankDetailPage> createState() => _TankDetailPageState();
}

class _TankDetailPageState extends State<TankDetailPage> {
  final FuelController fuelController = Get.find();
  String selectedTimeFrame = 'Day';
  String selectedDay = DateFormat('EEEE').format(DateTime.now());
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final data = await fuelController.getChartData(
      widget.tankIndex,
      selectedTimeFrame,
      selectedDay: selectedDay,
      selectedMonth: selectedMonth,
      selectedYear: selectedYear,
    );
    print("Received chart data: $data");
    setState(() {
      chartData = data
          .map((item) => ChartData(
                item['time'],
                item['level'],
              ))
          .toList();
    });
    print("Processed chart data: $chartData");
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              color: AppColor.bg,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
          Container(
            height: screenHeight,
            width: screenWidth,
            child: Image.asset(
              AppAsset.bg1,
              alignment: Alignment.bottomRight,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          'Fuel Level Monitor',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.white.withOpacity(0.9),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "Fuel Level Ratio",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Obx(
                                        () => Text(
                                            '${fuelController.getFuelLevelText(widget.tankIndex)} %'),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          "Fuel Level Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Obx(() => Text(
                                          '${fuelController.getFuelStatus(widget.tankIndex)}'))
                                    ],
                                  ),
                                  Obx(
                                    () => FuelTankWidget(
                                      tankName: 'Tank ${widget.tankIndex + 1}',
                                      fuelLevel: fuelController
                                          .getFuelLevel(widget.tankIndex),
                                      onTap: () {},
                                      width: 150,
                                      height: 300,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Card(
                            color: Colors.white.withOpacity(0.9),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Fuel Level Depth',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          SizedBox(height: 16),
                          Card(
                            color: Colors.white.withOpacity(0.9),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Fuel Level Depth',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildTimeFrameButton('Day'),
                                      _buildTimeFrameButton('Month'),
                                      _buildTimeFrameButton('Year'),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    height: 300,
                                    child: StreamBuilder<
                                        List<Map<String, dynamic>>>(
                                      stream: fuelController.getChartDataStream(
                                        widget.tankIndex,
                                        selectedTimeFrame,
                                        selectedDay: selectedDay,
                                        selectedMonth: selectedMonth,
                                        selectedYear: selectedYear,
                                      ),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          final chartData = snapshot.data!
                                              .map((item) => ChartData(
                                                    item['time'],
                                                    item['level'],
                                                  ))
                                              .toList();
                                          return SfCartesianChart(
                                            primaryXAxis: DateTimeAxis(
                                              dateFormat: selectedTimeFrame ==
                                                      'Day'
                                                  ? DateFormat.Hm()
                                                  : selectedTimeFrame == 'Month'
                                                      ? DateFormat.MMMd()
                                                      : DateFormat.MMM(),
                                              intervalType: selectedTimeFrame ==
                                                      'Day'
                                                  ? DateTimeIntervalType.hours
                                                  : selectedTimeFrame == 'Month'
                                                      ? DateTimeIntervalType
                                                          .days
                                                      : DateTimeIntervalType
                                                          .months,
                                              interval:
                                                  selectedTimeFrame == 'Year'
                                                      ? 1
                                                      : null,
                                            ),
                                            primaryYAxis: NumericAxis(
                                              minimum: 0,
                                              maximum: 1,
                                              numberFormat:
                                                  NumberFormat.percentPattern(),
                                            ),
                                            series: <ChartSeries>[
                                              LineSeries<ChartData, DateTime>(
                                                dataSource: chartData,
                                                xValueMapper:
                                                    (ChartData data, _) =>
                                                        data.time,
                                                yValueMapper:
                                                    (ChartData data, _) =>
                                                        data.level,
                                              )
                                            ],
                                            tooltipBehavior:
                                                TooltipBehavior(enable: true),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  if (selectedTimeFrame == 'Day')
                                    Center(
                                      child: DropdownButton<String>(
                                        value: selectedDay,
                                        dropdownColor: Colors.lightBlue,
                                        focusColor: Colors.lightBlue,
                                        iconEnabledColor: Colors.lightBlue,
                                        items: [
                                          'Monday',
                                          'Tuesday',
                                          'Wednesday',
                                          'Thursday',
                                          'Friday',
                                          'Saturday',
                                          'Sunday'
                                        ]
                                            .map((day) => DropdownMenuItem(
                                                value: day, child: Text(day)))
                                            .toList(),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            setState(
                                                () => selectedDay = newValue);
                                            _loadChartData();
                                          }
                                        },
                                      ),
                                    ),
                                  if (selectedTimeFrame == 'Month')
                                    Center(
                                      child: DropdownButton<int>(
                                        dropdownColor: Colors.lightBlue,
                                        focusColor: Colors.lightBlue,
                                        iconEnabledColor: Colors.lightBlue,
                                        value: selectedMonth,
                                        items: List.generate(12, (index) {
                                          return DropdownMenuItem(
                                            value: index + 1,
                                            child: Text(DateFormat('MMMM')
                                                .format(
                                                    DateTime(2022, index + 1))),
                                          );
                                        }),
                                        onChanged: (int? newValue) {
                                          if (newValue != null) {
                                            setState(
                                                () => selectedMonth = newValue);
                                            _loadChartData();
                                          }
                                        },
                                      ),
                                    ),
                                  if (selectedTimeFrame == 'Year')
                                    Center(
                                      child: DropdownButton<int>(
                                        dropdownColor: Colors.lightBlue,
                                        focusColor: Colors.lightBlue,
                                        iconEnabledColor: Colors.lightBlue,
                                        value: selectedYear,
                                        items: List.generate(17, (index) {
                                          int year = 2024 + index;
                                          return DropdownMenuItem(
                                              value: year,
                                              child: Text(year.toString()));
                                        }),
                                        onChanged: (int? newValue) {
                                          if (newValue != null) {
                                            setState(
                                                () => selectedYear = newValue);
                                            _loadChartData();
                                          }
                                        },
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTimeFrameButton(String timeFrame) {
    return ElevatedButton(
      onPressed: () {
        setState(() => selectedTimeFrame = timeFrame);
      },
      child: Text(timeFrame),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedTimeFrame == timeFrame
            ? Colors.lightBlue
            : Colors.transparent,
      ),
    );
  }
}

class ChartData {
  ChartData(this.time, this.level);
  final DateTime time;
  final double level;

  @override
  String toString() => 'ChartData(time: $time, level: $level)';
}
