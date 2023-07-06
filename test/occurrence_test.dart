import 'package:todo/model/occurrence.dart';
import 'package:test/test.dart';

void main() {
  test('oneshot prev', () {
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .prev(DateTime(2021, 1, 1, 0, 0)),
        DateTime(2020, 1, 1, 12, 0));
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .prev(DateTime(2020, 1, 1, 13, 0)),
        DateTime(2020, 1, 1, 12, 0));
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .prev(DateTime(2020, 1, 1, 11, 0)),
        isNull);
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .prev(DateTime(2019, 1, 1, 0, 0)),
        isNull);
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .prev(DateTime(2020, 1, 1, 12, 0)),
        isNull);
  });
  test('oneshot next', () {
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .next(DateTime(2019, 1, 1, 12, 0)),
        DateTime(2020, 1, 1, 12, 0));
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .next(DateTime(2020, 1, 1, 11, 0)),
        DateTime(2020, 1, 1, 12, 0));
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .next(DateTime(2020, 1, 1, 13, 0)),
        isNull);
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 12, 0))
            .next(DateTime(2021, 1, 1, 12, 0)),
        isNull);
    expect(
        OccurrenceOneshot(DateTime(2020, 1, 1, 0, 0))
            .next(DateTime(2020, 1, 1, 0, 0)),
        isNull);
  });

  test('daily prev', () {
    expect(const OccurrenceDaily(Time(12, 0)).prev(DateTime(2020, 1, 1, 0, 0)),
        DateTime(2019, 12, 31, 12, 0));
    expect(const OccurrenceDaily(Time(12, 0)).prev(DateTime(2020, 1, 1, 13, 0)),
        DateTime(2020, 1, 1, 12, 0));
    expect(const OccurrenceDaily(Time(12, 0)).prev(DateTime(2020, 1, 1, 11, 0)),
        DateTime(2019, 12, 31, 12, 0));
    expect(const OccurrenceDaily(Time(12, 0)).prev(DateTime(2020, 1, 1, 12, 0)),
        DateTime(2019, 12, 31, 12, 0));
  });
  test('oneshot next', () {
    expect(const OccurrenceDaily(Time(12, 0)).next(DateTime(2020, 1, 1, 0, 0)),
        DateTime(2020, 1, 1, 12, 0));
    expect(const OccurrenceDaily(Time(12, 0)).next(DateTime(2020, 1, 1, 13, 0)),
        DateTime(2020, 1, 2, 12, 0));
    expect(const OccurrenceDaily(Time(12, 0)).next(DateTime(2020, 1, 1, 11, 0)),
        DateTime(2020, 1, 1, 12, 0));
    expect(const OccurrenceDaily(Time(12, 0)).next(DateTime(2020, 1, 1, 12, 0)),
        DateTime(2020, 1, 2, 12, 0));
  });
}
