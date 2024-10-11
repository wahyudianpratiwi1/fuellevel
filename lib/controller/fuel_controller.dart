import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fuellevel_monitoring/model/sensor_model.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class FuelController extends GetxController {
  final firestore = FirebaseFirestore.instance;
  final database = FirebaseDatabase.instance.ref();
  final sensor = Sensor().obs;

  @override
  void onInit() {
    super.onInit();
    _listenToFuelLevels();
  }

  void _listenToFuelLevels() {
    database.child('Sensor').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final newSensor = Sensor.fromJson(Map<String, dynamic>.from(data));
        sensor.value = newSensor;
        _saveSensorToFirestore(newSensor);
        update();
      }
    }, onError: (error) {
      print("Error listening to fuel levels: $error");
    });
  }

  Future<void> _saveSensorToFirestore(Sensor sensor) async {
    try {
      for (int i = 1; i <= 6; i++) {
        final sensorValue = sensor.toJson()['Sensor_$i'];
        if (sensorValue != null) {
          await firestore
              .collection('sensors')
              .doc('sensor$i')
              .collection('readings')
              .add({
            'value': sensorValue,
            'timestamp': FieldValue.serverTimestamp(),
          });
        }
      }
      print("Data saved to Firestore successfully");
    } catch (e) {
      print("Error saving to Firestore: $e");
    }
  }

  double getFuelLevel(int tankIndex) {
    final sensorValue = sensor.value.toJson()['Sensor_${tankIndex + 1}'];
    return sensorValue != null ? sensorValue / 100 : 0.0;
  }

  double getFuelLevelText(int tankIndex) {
    return getFuelLevel(tankIndex) * 100;
  }

  String getFuelStatus(int tankIndex) {
    double level = getFuelLevel(tankIndex);
    if (level < 0.2) return 'Low';
    if (level < 0.6) return 'Middle';
    return 'High';
  }

  Stream<List<Map<String, dynamic>>> getChartDataStream(
    int tankIndex,
    String timeFrame, {
    String? selectedDay,
    int? selectedMonth,
    int? selectedYear,
  }) {
    final now = DateTime.now();
    DateTime startTime;
    DateTime endTime;

    switch (timeFrame) {
      case 'Day':
        startTime = _getSelectedDate(selectedDay!, selectedYear ?? now.year);
        endTime = startTime.add(Duration(days: 1));
        break;
      case 'Month':
        startTime =
            DateTime(selectedYear ?? now.year, selectedMonth ?? now.month, 1);
        endTime = DateTime(
            selectedYear ?? now.year, (selectedMonth ?? now.month) + 1, 1);
        break;
      case 'Year':
        startTime = DateTime(selectedYear ?? now.year, 1, 1);
        endTime = DateTime((selectedYear ?? now.year) + 1, 1, 1);
        break;
      default:
        startTime = now.subtract(const Duration(days: 1));
        endTime = now;
    }

    return firestore
        .collection('sensors')
        .doc('sensor${tankIndex + 1}')
        .collection('readings')
        .where('timestamp', isGreaterThanOrEqualTo: startTime)
        .where('timestamp', isLessThan: endTime)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      List<Map<String, dynamic>> result = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'time': (data['timestamp'] as Timestamp).toDate(),
          'level': (data['value'] as num).toDouble() / 100,
        };
      }).toList();

      if (timeFrame == 'Month' || timeFrame == 'Year') {
        result = _groupAndAverageData(result, timeFrame);
      }

      return result;
    });
  }

  Future<List<Map<String, dynamic>>> getChartData(
    int tankIndex,
    String timeFrame, {
    String? selectedDay,
    int? selectedMonth,
    int? selectedYear,
  }) async {
    try {
      final now = DateTime.now();
      DateTime startTime;
      DateTime endTime;

      switch (timeFrame) {
        case 'Day':
          startTime = _getSelectedDate(selectedDay!, selectedYear ?? now.year);
          endTime = startTime.add(Duration(days: 1));
          break;
        case 'Month':
          startTime =
              DateTime(selectedYear ?? now.year, selectedMonth ?? now.month, 1);
          endTime = DateTime(
              selectedYear ?? now.year, (selectedMonth ?? now.month) + 1, 1);
          break;
        case 'Year':
          startTime = DateTime(selectedYear ?? now.year, 1, 1);
          endTime = DateTime((selectedYear ?? now.year) + 1, 1, 1);
          break;
        default:
          startTime = now.subtract(const Duration(days: 1));
          endTime = now;
      }

      print("Fetching data for sensor$tankIndex from $startTime to $endTime");

      QuerySnapshot querySnapshot = await firestore
          .collection('sensors')
          .doc('sensor${tankIndex + 1}')
          .collection('readings')
          .where('timestamp', isGreaterThanOrEqualTo: startTime)
          .where('timestamp', isLessThan: endTime)
          .orderBy('timestamp')
          .get();

      List<Map<String, dynamic>> result = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'time': (data['timestamp'] as Timestamp).toDate(),
          'level': (data['value'] as num).toDouble() / 100,
        };
      }).toList();

      // Group data for month and year views
      if (timeFrame == 'Month' || timeFrame == 'Year') {
        result = _groupAndAverageData(result, timeFrame);
      }

      print("Processed data: $result");
      return result;
    } catch (e) {
      print("Error fetching chart data: $e");
      return [];
    }
  }

  List<Map<String, dynamic>> _groupAndAverageData(
      List<Map<String, dynamic>> data, String timeFrame) {
    Map<String, List<double>> groupedData = {};

    for (var item in data) {
      DateTime time = item['time'];
      double level = item['level'];
      String key;

      switch (timeFrame) {
        case 'Month':
          key = DateFormat('yyyy-MM-dd').format(time); // Group by day
          break;
        case 'Year':
          key = DateFormat('yyyy-MM').format(time); // Group by month
          break;
        default:
          key = DateFormat('yyyy-MM-dd HH:mm').format(time); // No grouping
      }

      if (!groupedData.containsKey(key)) {
        groupedData[key] = [];
      }
      groupedData[key]!.add(level);
    }

    return groupedData.entries.map((entry) {
      double averageLevel =
          entry.value.reduce((a, b) => a + b) / entry.value.length;
      DateTime parsedTime;
      if (timeFrame == 'Year') {
        // For yearly view, use the first day of the month
        parsedTime = DateTime.parse(entry.key + '-01');
      } else {
        parsedTime = DateTime.parse(entry.key);
      }
      return {
        'time': parsedTime,
        'level': averageLevel,
      };
    }).toList()
      ..sort(
          (a, b) => (a['time'] as DateTime).compareTo(b['time'] as DateTime));
  }

  DateTime _getSelectedDate(String selectedDay, int year) {
    final now = DateTime.now();
    final daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final selectedDayIndex = daysOfWeek.indexOf(selectedDay);
    final currentDayIndex = now.weekday - 1; // 0 = Monday, 6 = Sunday
    int daysToSubtract = currentDayIndex - selectedDayIndex;
    if (daysToSubtract < 0) daysToSubtract += 7;
    return DateTime(year, now.month, now.day - daysToSubtract);
  }
}
