import 'package:todo/model/occurrence.dart';

class Task {
  final String title;
  final Occurrence occurrence;
  final Duration duration;
  final DateTime? lastDone;

  const Task(
      {required this.title,
      required this.occurrence,
      required this.duration,
      this.lastDone});

  Task complete(DateTime now) => Task(
        title: title,
        occurrence: occurrence,
        duration: duration,
        lastDone: now,
      );
}

class FixedTask {
  final Task task;
  final DateTime occurs;

  const FixedTask(this.task, this.occurs);

  DateTime get deadline => occurs.add(task.duration);

  bool completed(DateTime now) =>
      null != task.lastDone ? occurs.compareTo(task.lastDone!) <= 0 : false;

  bool active(DateTime now) => occurs.compareTo(now) < 0 && !completed(now);
}
