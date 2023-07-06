abstract class Occurrence {
  static const delta = Duration(minutes: 1);

  const Occurrence();

  DateTime? prev(DateTime now);
  DateTime? next(DateTime now);

  List<DateTime> calcAllNextUntil(DateTime now, DateTime until) {
    final ret = <DateTime>[];
    while (true) {
      final calculated = next(now);
      if (null == calculated || calculated.compareTo(until) >= 0) {
        break;
      }
      now = calculated;
      ret.add(now);
    }
    return ret;
  }

  static DateTime strip(DateTime src) =>
      DateTime(src.year, src.month, src.day, src.hour, src.minute);
}

class OccurrenceOneshot extends Occurrence {
  final DateTime date;

  const OccurrenceOneshot(this.date);

  @override
  String toString() => "oneshot ($date)";

  @override
  DateTime? prev(DateTime now) =>
      Occurrence.strip(now).compareTo(date) > 0 ? date : null;
  @override
  DateTime? next(DateTime now) =>
      Occurrence.strip(now).compareTo(date) < 0 ? date : null;
}

class Time {
  final int h, m;

  const Time(this.h, this.m);
  Time.fromDateTime(DateTime dt)
      : h = dt.hour,
        m = dt.minute;

  @override
  String toString() =>
      "${h.toString().padLeft(2, "0")}:${m.toString().padLeft(2, "0")}";
}

class OccurrenceDaily extends Occurrence {
  final Time time;

  const OccurrenceDaily(this.time);

  @override
  String toString() => "daily ($time)";

  @override
  DateTime prev(DateTime now) {
    now = Occurrence.strip(now);
    final today = now.copyWith(
      hour: time.h,
      minute: time.m,
    );
    return today.compareTo(now) < 0
        ? today
        : today.subtract(const Duration(days: 1));
  }

  @override
  DateTime next(DateTime now) =>
      prev(now.add(Occurrence.delta)).add(const Duration(days: 1));
}

class OccurrenceWeekly extends Occurrence {
  static const weekdayNames = <String>[
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
  ];

  final int weekday; /* sunday(0)~saturdary(6) */
  final Time time;

  const OccurrenceWeekly(this.weekday, this.time);

  @override
  String toString() => "weekly (${weekdayNames[weekday]})";

  @override
  DateTime prev(DateTime now) {
    now = Occurrence.strip(now);
    final diff = ((weekday - 1) % 7 + 1) - now.weekday;
    final ret = now
        .add(Duration(days: diff))
        .subtract(diff > 0 ? const Duration(days: 7) : Duration.zero);
    return ret.subtract(
        now.compareTo(ret) < 0 ? const Duration(days: 7) : Duration.zero);
  }

  @override
  DateTime next(DateTime now) =>
      prev(now.add(Occurrence.delta)).add(const Duration(days: 7));
}
