import 'package:equatable/equatable.dart';

class ReminderTime extends Equatable {
  const ReminderTime({required this.hour, required this.minute});

  factory ReminderTime.parse(String s) {
    final parts = s.split(':');
    return ReminderTime(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  final int hour;
  final int minute;

  String toStorageString() =>
      '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';

  static List<ReminderTime> parseList(String csv) {
    if (csv.isEmpty) return const [ReminderTime(hour: 8, minute: 0)];
    return csv.split(',').map(ReminderTime.parse).toList();
  }

  static String toStorageList(List<ReminderTime> times) =>
      times.map((t) => t.toStorageString()).join(',');

  static List<String> toFirestoreList(List<ReminderTime> times) =>
      times.map((t) => t.toStorageString()).toList();

  static List<ReminderTime> fromFirestoreList(List<dynamic> list) =>
      list.map((e) => ReminderTime.parse(e as String)).toList();

  @override
  List<Object> get props => [hour, minute];
}
