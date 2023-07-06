import 'package:flutter/material.dart';
import 'package:todo/model/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;
  const TaskListTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(task.title),
        subtitle: Text(task.occurrence.toString()),
      );
}
