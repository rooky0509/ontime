import 'package:intl/intl.dart';

extension Time on DateTime {
  DateTime set({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
  DateTime setTime({
    int? hour,
    int? minute,
    int? second,
  }) {
    return DateTime(
      this.year,
      this.month,
      this.day,
      hour ?? 0,
      minute ?? 0,
      second ?? 0,
    );
  }
  int toSec() {
    return this.hour*3600 + this.minute*60 + this.second;
  }
  String format({String? newPattern}) {
    return DateFormat(newPattern??"hh:mm:ss").format(this);
  }
}