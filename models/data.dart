class DayData {
  final String date;
  final double voltage;
  final double power;
  final double current;

  DayData({
    required this.date,
    required this.voltage,
    required this.power,
    required this.current,
  });

  factory DayData.fromMap(Map<String, dynamic> map) {
    return DayData(
      date: map['date'],
      voltage: double.tryParse(map['voltage']) ?? 0.0,
      power: double.tryParse(map['power']) ?? 0.0,
      current: double.tryParse(map['current']) ?? 0.0,
    );
  }
}
