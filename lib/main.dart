import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/feature/task_list/task_list_page.dart';
import 'package:todo/feature/task_list/task_list_repository.dart';
import 'package:todo/feature/weekly_view/weekly_view_repository.dart';
import 'package:todo/model/occurrence.dart';
import 'package:todo/model/task.dart';

class InMemoryTaskProvider implements TaskListRepository, WeeklyViewRepository {
  final _tasks = <Task>{
    const Task(
      title: "hello",
      occurrence: OccurrenceDaily(Time(0, 0)),
      duration: Duration(days: 1),
    ),
    const Task(
      title: "world",
      occurrence: OccurrenceDaily(Time(0, 0)),
      duration: Duration(hours: 1),
    ),
  };

  @override
  Set<Task> fetch() => _tasks;

  @override
  void add(Task task) => _tasks.add(task);

  @override
  void remove(Task task) => _tasks.remove(task);
}

void main() {
  final taskProvider = InMemoryTaskProvider();
  runApp(
    MultiProvider(
      providers: [
        Provider<TaskListRepository>.value(value: taskProvider),
        Provider<WeeklyViewRepository>.value(value: taskProvider),
      ],
      child: const MaterialApp(
        home: TaskListPage(),
      ),
    ),
  );
}
