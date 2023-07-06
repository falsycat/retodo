import 'package:flutter/material.dart';
import 'package:todo/model/task.dart';
import 'package:humanize_duration/humanize_duration.dart';

class FixedTaskListTile extends StatelessWidget {
  final FixedTask fixed;
  const FixedTaskListTile({super.key, required this.fixed});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return ListTile(
      title: Text(
        fixed.task.title,
        style: TextStyle(
          color: fixed.occurs.compareTo(now) < 0
              ? fixed.deadline.compareTo(now) < 0
                  ? Colors.red
                  : Colors.green
              : Colors.black,
        ),
      ),
      subtitle: Text(
        fixed.occurs.compareTo(now) > 0
            ? "occurs in ${humanize(fixed.occurs.difference(now))}"
            : fixed.deadline.compareTo(now) > 0
                ? "expires in ${humanize(fixed.deadline.difference(now))}"
                : "EXPIRED before ${humanize(now.difference(fixed.deadline))}",
      ),
    );
  }

  String humanize(Duration dur) => humanizeDuration(dur,
      options: const HumanizeOptions(units: [
        Units.day,
        Units.hour,
        Units.minute,
      ]));
}
