import 'package:intl/intl.dart';

class Sensor {
  int? sensor1;
  int? sensor2;
  int? sensor3;
  int? sensor4;
  int? sensor5;
  int? sensor6;
  DateTime timestamp;

  Sensor({
    this.sensor1,
    this.sensor2,
    this.sensor3,
    this.sensor4,
    this.sensor5,
    this.sensor6,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
        sensor1: json["Sensor_1"],
        sensor2: json["Sensor_2"],
        sensor3: json["Sensor_3"],
        sensor4: json["Sensor_4"],
        sensor5: json["Sensor_5"],
        sensor6: json["Sensor_6"],
        timestamp: DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "Sensor_1": sensor1,
        "Sensor_2": sensor2,
        "Sensor_3": sensor3,
        "Sensor_4": sensor4,
        "Sensor_5": sensor5,
        "Sensor_6": sensor6,
        "timestamp": DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp),
      };
}
